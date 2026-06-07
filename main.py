import time
import re
import os
import bcrypt
from typing import List
from datetime import timedelta
from datetime import datetime, timezone
from fastapi import FastAPI, Depends, Request, HTTPException, Response, Header, Cookie
from fastapi.templating import Jinja2Templates
from fastapi.responses import HTMLResponse
from fastapi.staticfiles import StaticFiles
from sqlalchemy.orm import Session
from pydantic import BaseModel, validator
from collections import defaultdict
import models
from database import engine, get_db
from typing import Optional

try:
    models.Base.metadata.create_all(bind=engine)
    print("⚽ CONNECTED TO DATABASE!", flush=True)
except Exception as e:
    print(f"❌ BŁĄD POŁĄCZENIA Z BAZĄ DANYCH: {e}", flush=True)
    raise e

app = FastAPI(title="OnePick Cup 2026 API")
app.mount("/static", StaticFiles(directory="static"), name="static")
templates = Jinja2Templates(directory="templates")

ADMIN_SECRET = os.environ.get("ADMIN_SECRET", "change_me_in_env")

def hash_password(password: str) -> str:
    return bcrypt.hashpw(password.encode('utf-8'), bcrypt.gensalt()).decode('utf-8')

def verify_password(password: str, hashed: str) -> bool:
    return bcrypt.checkpw(password.encode('utf-8'), hashed.encode('utf-8'))

def verify_admin(x_admin_secret: str = Header(None)):
    if x_admin_secret != ADMIN_SECRET:
        raise HTTPException(status_code=403, detail="Brak dostępu — wymagany klucz admina")

class PlayerCreate(BaseModel):
    username: str
    email: str

class PlayerAuth(BaseModel):
    username: str
    password: str

class UserPickCreate(BaseModel):
    player_id: int
    match_id: int
    predicted_result: str

    @validator('predicted_result')
    def validate_score_format(cls, v):
        if not re.match(r'^\d{1,2}:\d{1,2}$', v):
            raise ValueError('Wynik musi być w formacie "X:Y", np. "2:1"')
        h, a = map(int, v.split(':'))
        if h > 20 or a > 20:
            raise ValueError('Wynik wygląda nieprawidłowo (maks. 20 goli)')
        return v

class MatchResultUpdate(BaseModel):
    result: str
    scorers: List[str] = []

    @validator('result')
    def validate_result_format(cls, v):
        if not re.match(r'^\d{1,2}:\d{1,2}$', v):
            raise ValueError('Wynik musi być w formacie "X:Y"')
        return v

class FavoriteTeamUpdate(BaseModel):
    favorite_team: str
    star_player: str = None

UNDERDOG_TEAMS = {
    "Haiti", "Curacao", "RPA", "Bośnia i Hercegowina",
    "Nowa Zelandia", "Arabia Saudyjska", "RZP", "Irak",
    "Jordania", "Uzbekistan", "DR Konga", "Panama"
}

STAGE_MULTIPLIERS = {
    "group": 1,
    "round_32": 1,
    "round_16": 1,
    "quarter": 1.5,
    "semi": 2,
    "final": 3
}

def now_utc():
    return datetime.now()

def get_upcoming_matches(db: Session, limit: int = 5):
    """Zwraca listę ID meczów, które są najbliższe (niezakończone, nie zablokowane, data > teraz)."""
    now = now_utc()
    matches = db.query(models.Match).filter(
        models.Match.is_finished == False,
        models.Match.is_locked == False,
        models.Match.match_date > now
    ).order_by(models.Match.match_date).limit(limit).all()
    return [m.id for m in matches]

def calculate_points_with_bonus(predicted: str, actual: str, match_stage: str, home_team: str, away_team: str, favorite_team: str = None, star_player: str = None, match_scorers: List[str] = []) -> dict:
    try:
        pred_h, pred_a = map(int, predicted.split(":"))
        act_h, act_a = map(int, actual.split(":"))
        total_goals = act_h + act_a

        # 1. Punkty bazowe (za typ)
        if pred_h == act_h and pred_a == act_a:
            base_points = 3
        elif (pred_h > pred_a and act_h > act_a) or (pred_h < pred_a and act_h < act_a) or (pred_h == pred_a and act_h == act_a):
            base_points = 1
        else:
            base_points = -2

        # 2. Bonus za wysoką liczbę bramek (tylko przy dokładnym wyniku)
        high_score_bonus = 0
        if base_points == 3:
            if total_goals >= 5:
                high_score_bonus = 2
            elif total_goals == 4:
                high_score_bonus = 1

        # 3. Bonus za underdoga (tylko przy trafionym typie – base_points > 0)
        underdog_bonus = 0
        if base_points > 0:
            if act_h > act_a and home_team in UNDERDOG_TEAMS:
                underdog_bonus = 2
            elif act_a > act_h and away_team in UNDERDOG_TEAMS:
                underdog_bonus = 2
            elif act_h == act_a and (home_team in UNDERDOG_TEAMS or away_team in UNDERDOG_TEAMS):
                underdog_bonus = 1

        # 4. Bonus za ulubioną drużynę (zawsze, gdy wygra – niezależnie od typu)
        favorite_bonus = 0
        if favorite_team:
            if (act_h > act_a and home_team == favorite_team) or (act_a > act_h and away_team == favorite_team):
                favorite_bonus = 1

        # 5. Bonus za gwiazdę (zawsze, gdy strzeli gola – niezależnie od typu)
        star_player_bonus = 0
        if star_player and match_scorers:
            star_player_bonus = match_scorers.count(star_player)

        multiplier = STAGE_MULTIPLIERS.get(match_stage, 1)

        # 6. Punkty końcowe
        if base_points < 0:
            # Błędny typ: kara -2 plus bonusy (favorite, star), bez mnożenia
            total_points = base_points + favorite_bonus + star_player_bonus
        else:
            # Trafiony typ: punkty bazowe + bonusy (underdog, high_score, favorite) są mnożone,
            # bonus za gwiazdę dodawany osobno (nie podlega mnożeniu)
            total_points = int((base_points + high_score_bonus + underdog_bonus + favorite_bonus) * multiplier) + star_player_bonus

        return {
            "base_points": base_points,
            "favorite_bonus": favorite_bonus,
            "star_player_bonus": star_player_bonus,
            "total_points": total_points
        }
    except Exception as e:
        print(f"Error calculating points: {e}")
        return {"total_points": 0, "base_points": 0, "favorite_bonus": 0, "star_player_bonus": 0}

TEAM_TO_GROUP = {
    "Meksyk": "A", "Korea Południowa": "A", "RPA": "A", "Czechy": "A",
    "Kanada": "B", "Szwajcaria": "B", "Katar": "B", "Bośnia i Hercegowina": "B",
    "Brazylia": "C", "Maroko": "C", "Szkocja": "C", "Haiti": "C",
    "USA": "D", "Australia": "D", "Paragwaj": "D", "Turcja": "D",
    "Niemcy": "E", "Ekwador": "E", "WKS": "E", "Curacao": "E",
    "Holandia": "F", "Japonia": "F", "Tunezja": "F", "Szwecja": "F",
    "Belgia": "G", "Iran": "G", "Egipt": "G", "Nowa Zelandia": "G",
    "Hiszpania": "H", "Urugwaj": "H", "Arabia Saudyjska": "H", "RZP": "H",
    "Francja": "I", "Senegal": "I", "Norwegia": "I", "Irak": "I",
    "Argentyna": "J", "Austria": "J", "Algieria": "J", "Jordania": "J",
    "Portugalia": "K", "Kolumbia": "K", "Uzbekistan": "K", "DR Konga": "K",
    "Anglia": "L", "Chorwacja": "L", "Panama": "L", "Ghana": "L"
}

GROUPS_LIST = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L"]

def calculate_group_standings(db: Session):
    matches = db.query(models.Match).filter(models.Match.is_finished == True).all()

    team_stats = defaultdict(lambda: {
        "played": 0, "won": 0, "drawn": 0, "lost": 0,
        "goals_for": 0, "goals_against": 0, "points": 0,
        "form": []
    })

    for match in matches:
        if match.result and ":" in match.result:
            try:
                home_goals, away_goals = map(int, match.result.split(":"))

                team_stats[match.home_team]["played"] += 1
                team_stats[match.home_team]["goals_for"] += home_goals
                team_stats[match.home_team]["goals_against"] += away_goals

                team_stats[match.away_team]["played"] += 1
                team_stats[match.away_team]["goals_for"] += away_goals
                team_stats[match.away_team]["goals_against"] += home_goals

                if home_goals > away_goals:
                    team_stats[match.home_team]["won"] += 1
                    team_stats[match.home_team]["points"] += 3
                    team_stats[match.away_team]["lost"] += 1
                    team_stats[match.home_team]["form"].append("W")
                    team_stats[match.away_team]["form"].append("L")
                elif home_goals < away_goals:
                    team_stats[match.away_team]["won"] += 1
                    team_stats[match.away_team]["points"] += 3
                    team_stats[match.home_team]["lost"] += 1
                    team_stats[match.away_team]["form"].append("W")
                    team_stats[match.home_team]["form"].append("L")
                else:
                    team_stats[match.home_team]["drawn"] += 1
                    team_stats[match.away_team]["drawn"] += 1
                    team_stats[match.home_team]["points"] += 1
                    team_stats[match.away_team]["points"] += 1
                    team_stats[match.home_team]["form"].append("D")
                    team_stats[match.away_team]["form"].append("D")
            except:
                pass

    groups_data = {}
    for group in GROUPS_LIST:
        group_teams = []
        for team, g in TEAM_TO_GROUP.items():
            if g == group:
                stats = team_stats[team]
                stats["goal_diff"] = stats["goals_for"] - stats["goals_against"]
                stats["form_str"] = "".join(stats["form"][-3:]) if stats["form"] else "-"
                group_teams.append({"name": team, **stats})

        group_teams.sort(key=lambda x: (x["points"], x["goal_diff"], x["goals_for"]), reverse=True)
        groups_data[group] = group_teams

    return groups_data

def build_knockout_bracket(db: Session):
    bracket = {
        "round_of_32": [], "round_of_16": [], "quarterfinals": [], "semifinals": [], "final": [], "third_place": []
    }
    knockout_matches = db.query(models.Match).filter(
        models.Match.stage.in_(["round_32", "round_16", "quarter", "semi", "final", "third_place"])
    ).order_by(models.Match.match_date).all()

    for match in knockout_matches:
        if match.stage == "round_32": bracket["round_of_32"].append(match)
        elif match.stage == "round_16": bracket["round_of_16"].append(match)
        elif match.stage == "quarter": bracket["quarterfinals"].append(match)
        elif match.stage == "semi": bracket["semifinals"].append(match)
        elif match.stage == "third_place": bracket["third_place"].append(match)
        elif match.stage == "final":
            if "3 miejsce" in match.home_team or "3 miejsce" in match.away_team:
                bracket["third_place"].append(match)
            else:
                bracket["final"].append(match)
    return bracket

@app.get("/players/{player_id}")
def get_player(player_id: int, db: Session = Depends(get_db)):
    player = db.query(models.Player).filter(models.Player.id == player_id).first()
    if not player:
        raise HTTPException(status_code=404, detail="Player not found")
    return {
        "id": player.id,
        "username": player.username,
        "total_points": player.total_points,
        "correct_predictions": player.correct_predictions,
        "current_streak": player.current_streak,
        "longest_streak": player.longest_streak,
        "favorite_team": player.favorite_team,
        "star_player": player.star_player,
        "favorite_team_points": player.favorite_team_points,
        "star_player_points": player.star_player_points,
        "favorite_locked": player.favorite_locked
    }

@app.post("/auth/register/")
def register_user(auth: PlayerAuth, response: Response, db: Session = Depends(get_db)):
    if db.query(models.Player).filter(models.Player.username == auth.username).first():
        raise HTTPException(status_code=400, detail="Nazwa gracza zajęta!")

    hashed_password = hash_password(auth.password)
    new_player = models.Player(
        username=auth.username,
        password=hashed_password,
        email=f"{auth.username}@onepick.pl"
    )
    db.add(new_player)
    db.commit()
    db.refresh(new_player)

    response.set_cookie(key="player_id", value=str(new_player.id), max_age=2592000, httponly=True, samesite="lax")
    return {"status": "ok"}

@app.post("/auth/login/")
def login_user(auth: PlayerAuth, response: Response, db: Session = Depends(get_db)):
    player = db.query(models.Player).filter(models.Player.username == auth.username).first()
    if not player or not verify_password(auth.password, player.password):
        raise HTTPException(status_code=400, detail="Błędny login lub hasło!")

    response.set_cookie(key="player_id", value=str(player.id), max_age=2592000, httponly=True, samesite="lax")
    return {"status": "ok"}

@app.post("/auth/logout/")
def logout_user(response: Response):
    response.delete_cookie("player_id")
    return {"status": "ok"}

@app.post("/seed/", dependencies=[Depends(verify_admin)])
def seed_database(db: Session = Depends(get_db)):
    if db.query(models.Match).count() > 0:
        return {"status": "already_seeded"}

    schedule_raw = [
        ("2026-06-11", "21:00", "Meksyk", "RPA", "group"),
        ("2026-06-12", "04:00", "Korea Południowa", "Czechy", "group"),
        ("2026-06-12", "21:00", "Kanada", "Bośnia i Hercegowina", "group"),
        ("2026-06-13", "03:00", "USA", "Paragwaj", "group"),
        ("2026-06-13", "21:00", "Katar", "Szwajcaria", "group"),
        ("2026-06-14", "00:00", "Brazylia", "Maroko", "group"),
        ("2026-06-14", "03:00", "Haiti", "Szkocja", "group"),
        ("2026-06-14", "06:00", "Australia", "Turcja", "group"),
        ("2026-06-14", "19:00", "Niemcy", "Curacao", "group"),
        ("2026-06-14", "22:00", "Holandia", "Japonia", "group"),
        ("2026-06-15", "01:00", "WKS", "Ekwador", "group"),
        ("2026-06-15", "04:00", "Szwecja", "Tunezja", "group"),
        ("2026-06-15", "18:00", "Hiszpania", "RZP", "group"),
        ("2026-06-15", "21:00", "Belgia", "Egipt", "group"),
        ("2026-06-16", "00:00", "Arabia Saudyjska", "Urugwaj", "group"),
        ("2026-06-16", "03:00", "Iran", "Nowa Zelandia", "group"),
        ("2026-06-16", "21:00", "Francja", "Senegal", "group"),
        ("2026-06-17", "00:00", "Irak", "Norwegia", "group"),
        ("2026-06-17", "03:00", "Argentyna", "Algieria", "group"),
        ("2026-06-17", "06:00", "Austria", "Jordania", "group"),
        ("2026-06-17", "19:00", "Portugalia", "DR Konga", "group"),
        ("2026-06-17", "22:00", "Anglia", "Chorwacja", "group"),
        ("2026-06-18", "01:00", "Ghana", "Panama", "group"),
        ("2026-06-18", "04:00", "Uzbekistan", "Kolumbia", "group"),
        ("2026-06-18", "18:00", "Czechy", "RPA", "group"),
        ("2026-06-18", "21:00", "Szwajcaria", "Bośnia i Hercegowina", "group"),
        ("2026-06-19", "00:00", "Kanada", "Katar", "group"),
        ("2026-06-19", "03:00", "Meksyk", "Korea Południowa", "group"),
        ("2026-06-19", "21:00", "USA", "Australia", "group"),
        ("2026-06-20", "00:00", "Szkocja", "Maroko", "group"),
        ("2026-06-20", "03:00", "Brazylia", "Haiti", "group"),
        ("2026-06-20", "06:00", "Turcja", "Paragwaj", "group"),
        ("2026-06-20", "19:00", "Holandia", "Szwecja", "group"),
        ("2026-06-20", "22:00", "Niemcy", "WKS", "group"),
        ("2026-06-21", "02:00", "Ekwador", "Curacao", "group"),
        ("2026-06-21", "06:00", "Tunezja", "Japonia", "group"),
        ("2026-06-21", "18:00", "Hiszpania", "Arabia Saudyjska", "group"),
        ("2026-06-21", "21:00", "Belgia", "Iran", "group"),
        ("2026-06-22", "00:00", "Urugwaj", "RZP", "group"),
        ("2026-06-22", "03:00", "Nowa Zelandia", "Egipt", "group"),
        ("2026-06-22", "19:00", "Argentyna", "Austria", "group"),
        ("2026-06-22", "23:00", "Francja", "Irak", "group"),
        ("2026-06-23", "02:00", "Norwegia", "Senegal", "group"),
        ("2026-06-23", "05:00", "Jordania", "Algieria", "group"),
        ("2026-06-23", "19:00", "Portugalia", "Uzbekistan", "group"),
        ("2026-06-23", "22:00", "Anglia", "Ghana", "group"),
        ("2026-06-24", "01:00", "Panama", "Chorwacja", "group"),
        ("2026-06-24", "04:00", "Kolumbia", "DR Konga", "group"),
        ("2026-06-24", "21:00", "Szwajcaria", "Kanada", "group"),
        ("2026-06-24", "21:00", "Bośnia i Hercegowina", "Katar", "group"),
        ("2026-06-25", "00:00", "Maroko", "Haiti", "group"),
        ("2026-06-25", "00:00", "Szkocja", "Brazylia", "group"),
        ("2026-06-25", "03:00", "RPA", "Korea Południowa", "group"),
        ("2026-06-25", "03:00", "Czechy", "Meksyk", "group"),
        ("2026-06-25", "22:00", "Curacao", "WKS", "group"),
        ("2026-06-25", "22:00", "Ekwador", "Niemcy", "group"),
        ("2026-06-26", "01:00", "Japonia", "Szwecja", "group"),
        ("2026-06-26", "01:00", "Tunezja", "Holandia", "group"),
        ("2026-06-26", "04:00", "Paragwaj", "Australia", "group"),
        ("2026-06-26", "04:00", "Turcja", "USA", "group"),
        ("2026-06-26", "21:00", "Norwegia", "Francja", "group"),
        ("2026-06-26", "21:00", "Senegal", "Irak", "group"),
        ("2026-06-27", "02:00", "RZP", "Arabia Saudyjska", "group"),
        ("2026-06-27", "02:00", "Urugwaj", "Hiszpania", "group"),
        ("2026-06-27", "05:00", "Egipt", "Iran", "group"),
        ("2026-06-27", "05:00", "Nowa Zelandia", "Belgia", "group"),
        ("2026-06-27", "23:00", "Chorwacja", "Ghana", "group"),
        ("2026-06-27", "23:00", "Panama", "Anglia", "group"),
        ("2026-06-28", "01:30", "DR Konga", "Uzbekistan", "group"),
        ("2026-06-28", "01:30", "Kolumbia", "Portugalia", "group"),
        ("2026-06-28", "04:00", "Algieria", "Austria", "group"),
        ("2026-06-28", "04:00", "Jordania", "Argentyna", "group"),
    ]

    matches_added = 0
    for date_str, time_str, home, away, stage in schedule_raw:
        dt_str = f"{date_str} {time_str}"
        try:
            match_datetime = datetime.strptime(dt_str, "%Y-%m-%d %H:%M")
        except: continue

        multiplier = STAGE_MULTIPLIERS.get(stage, 1)
        match = models.Match(
            home_team=home, away_team=away, match_date=match_datetime,
            stage=stage, multiplier=multiplier, is_locked=False, is_finished=False, result=None
        )
        db.add(match)
        matches_added += 1

    db.commit()
    return {"status": "ok", "matches_added": matches_added}

@app.get("/", response_class=HTMLResponse)
def read_dashboard(request: Request, db: Session = Depends(get_db)):
    players = db.query(models.Player).all()
    matches = db.query(models.Match).order_by(models.Match.match_date).all()
    picks = db.query(models.UserPick).all()

    leaderboard = db.query(models.Player).order_by(models.Player.total_points.desc()).limit(10).all()
    all_players = db.query(models.Player).order_by(models.Player.total_points.desc()).all()

    player_id = request.cookies.get("player_id")
    current_player = None
    if player_id:
        try:
            current_player = db.query(models.Player).filter(models.Player.id == int(player_id)).first()
        except (ValueError, TypeError): pass

    pick_stats = {m.id: {"home": 0, "draw": 0, "away": 0, "total": 0} for m in matches}
    for p in picks:
        if p.match_id in pick_stats and p.predicted_result:
            try:
                h, a = map(int, p.predicted_result.split(":"))
                pick_stats[p.match_id]["total"] += 1
                if h > a: pick_stats[p.match_id]["home"] += 1
                elif h < a: pick_stats[p.match_id]["away"] += 1
                else: pick_stats[p.match_id]["draw"] += 1
            except: pass

    group_standings = calculate_group_standings(db)
    knockout_bracket = build_knockout_bracket(db)
    upcoming_match_ids = get_upcoming_matches(db, 5)


    active_picks = []
    if current_player:
        for pick in picks:
            if pick.player_id == current_player.id:
                match = db.query(models.Match).filter(models.Match.id == pick.match_id).first()
                if match and not match.is_finished:
                    active_picks.append(pick)

    return templates.TemplateResponse(
        request=request, name="index.html",
        context={
            "players": players, "matches": matches, "leaderboard": leaderboard,
            "all_players": all_players, "picks": picks,
            "current_player": current_player, "active_picks": active_picks,
            "group_standings": group_standings, "knockout_bracket": knockout_bracket,
            "pick_stats": pick_stats, "now": now_utc, "timedelta": timedelta, "upcoming_match_ids": upcoming_match_ids
        }
    )

@app.get("/players/{player_id}/public")
def get_player_public(player_id: int, db: Session = Depends(get_db)):
    p = db.query(models.Player).filter(models.Player.id == player_id).first()
    if not p: raise HTTPException(404)
    return {
        "id": p.id, "username": p.username, "total_points": p.total_points,
        "correct_predictions": p.correct_predictions, "current_streak": p.current_streak,
        "longest_streak": p.longest_streak,
        "favorite_team": p.favorite_team, "star_player": p.star_player,
        "favorite_team_points": p.favorite_team_points, "star_player_points": p.star_player_points
    }

@app.get("/players/{player_id}/picks/public")
def get_player_picks_public(player_id: int, db: Session = Depends(get_db)):
    picks = db.query(models.UserPick).filter(models.UserPick.player_id == player_id).join(models.Match).order_by(models.Match.match_date).all()
    res = []
    for pick in picks:
        m = pick.match
        res.append({
            "match_date": m.match_date.isoformat(),
            "home_team": m.home_team,
            "away_team": m.away_team,
            "predicted_result": pick.predicted_result,   # zawsze widoczny
            "hidden": False,                              # zawsze false
            "actual_result": m.result,
            "points_earned": pick.points_earned,
            "is_finished": m.is_finished,
            "is_correct": pick.points_earned == 3 if m.is_finished else None
        })
    return res

@app.put("/players/{player_id}/favorite")
def set_favorite_team(
    player_id: int,
    favorite: FavoriteTeamUpdate,
    db: Session = Depends(get_db),
    session_player_id: Optional[str] = Cookie(None, alias="player_id"),
):
    if not session_player_id or int(session_player_id) != player_id:
        raise HTTPException(status_code=403, detail="Nie możesz zmieniać cudzych preferencji")

    player = db.query(models.Player).filter(models.Player.id == player_id).first()
    if not player:
        raise HTTPException(status_code=404, detail="Player not found")

    # 🔒 Jeśli już zablokowane – nie pozwól zmienić
    if player.favorite_locked:
        raise HTTPException(status_code=400, detail="Nie możesz już zmienić swojej drużyny ani gwiazdy")

    player.favorite_team = favorite.favorite_team
    player.star_player = favorite.star_player
    player.favorite_locked = True   # <----- BLOKUJEMY NA ZAWSZE
    db.commit()
    db.refresh(player)

    return {"status": "ok", "favorite_team": player.favorite_team, "star_player": player.star_player}

@app.post("/picks/")
def create_pick(pick: UserPickCreate, db: Session = Depends(get_db)):
    # Sprawdzenie czy gracz istnieje
    player = db.query(models.Player).filter(models.Player.id == pick.player_id).first()
    if not player:
        raise HTTPException(status_code=400, detail="Gracz nie istnieje")

    # Sprawdzenie czy mecz istnieje i nie jest zablokowany/zakończony
    match = db.query(models.Match).filter(models.Match.id == pick.match_id).first()
    if not match or match.is_locked or match.is_finished:
        raise HTTPException(status_code=400, detail="Mecz jest zablokowany")

    # ----- NOWA LOGIKA: tylko pierwsze 4 nadchodzące mecze -----
    upcoming_ids = get_upcoming_matches(db, limit=5)
    if pick.match_id not in upcoming_ids:
        raise HTTPException(status_code=400, detail="Można typować tylko 5 najbliższych meczy (kolejność dat)")

    # Policz ile typów gracz już oddał na te 4 mecze
    user_picks_count = db.query(models.UserPick).filter(
        models.UserPick.player_id == pick.player_id,
        models.UserPick.match_id.in_(upcoming_ids)
    ).count()
    if user_picks_count >= 5:
        raise HTTPException(status_code=400, detail="Możesz obstawić maksymalnie 5 meczy (wszystkie już wybrane)")

    # ----- KONIEC NOWEJ LOGIKI -----

    # Sprawdzenie czy typ na ten mecz już istnieje – jeśli tak, aktualizujemy
    existing = db.query(models.UserPick).filter(
        models.UserPick.player_id == pick.player_id,
        models.UserPick.match_id == pick.match_id
    ).first()

    if existing:
        existing.predicted_result = pick.predicted_result
        db.commit()
        return existing

    new_pick = models.UserPick(player_id=pick.player_id, match_id=pick.match_id, predicted_result=pick.predicted_result)
    db.add(new_pick)
    db.commit()
    return new_pick

@app.put("/matches/{match_id}/result", dependencies=[Depends(verify_admin)])
def update_match_result(match_id: int, result: MatchResultUpdate, db: Session = Depends(get_db)):
    match = db.query(models.Match).filter(models.Match.id == match_id).first()
    if not match: raise HTTPException(status_code=404)

    match.result = result.result
    match.scorers = result.scorers
    match.is_finished = True
    match.is_locked = True
    db.commit()

    picks = db.query(models.UserPick).filter(models.UserPick.match_id == match_id).all()

    for pick in picks:
        player = db.query(models.Player).filter(models.Player.id == pick.player_id).first()
        if not player: continue

        points_data = calculate_points_with_bonus(
            pick.predicted_result, result.result, match.stage,
            match.home_team, match.away_team, player.favorite_team,
            player.star_player, result.scorers
        )

        pick.points_earned = points_data["total_points"]

        # Bez eliminacji — wszyscy zdobywają/tracą punkty
        player.total_points += points_data["total_points"]

        # Śledzenie punktów z wyboru reprezentacji i gwiazdy
        player.favorite_team_points += points_data.get("favorite_bonus", 0)
        player.star_player_points += points_data.get("star_player_bonus", 0)

        # Seria trafień
        if points_data["base_points"] > 0:
            player.correct_predictions += 1
            player.current_streak += 1
            if player.current_streak > player.longest_streak:
                player.longest_streak = player.current_streak
        else:
            player.current_streak = 0

        db.commit()

    return {"status": "updated"}

@app.put("/matches/{match_id}/lock", dependencies=[Depends(verify_admin)])
def lock_match(match_id: int, db: Session = Depends(get_db)):
    match = db.query(models.Match).filter(models.Match.id == match_id).first()
    if match:
        match.is_locked = True
        db.commit()
    return {"status": "locked"}

@app.get("/next-match/")
def get_next_match_info(db: Session = Depends(get_db)):
    now = now_utc()
    next_match = db.query(models.Match).filter(
        models.Match.is_finished == False,
        models.Match.match_date > now
    ).order_by(models.Match.match_date).first()

    if not next_match: return {"has_next": False}

    time_left = next_match.match_date - now
    return {
        "has_next": True,
        "match_id": next_match.id,
        "home_team": next_match.home_team,
        "away_team": next_match.away_team,
        "days": time_left.days,
        "hours": time_left.seconds // 3600,
        "minutes": (time_left.seconds % 3600) // 60,
        "seconds": time_left.seconds % 60
    }

@app.get("/players/{player_id}/history/")
def get_player_history(player_id: int, db: Session = Depends(get_db)):
    picks = db.query(models.UserPick).filter(models.UserPick.player_id == player_id).join(models.Match).order_by(models.Match.match_date).all()
    history = []
    for pick in picks:
        match = pick.match
        history.append({
            "match_id": match.id,
            "home_team": match.home_team,
            "away_team": match.away_team,
            "match_date": match.match_date.isoformat(),
            "predicted_result": pick.predicted_result,
            "actual_result": match.result if match.is_finished else None,
            "points_earned": pick.points_earned,
            "is_finished": match.is_finished,
        })
    return history