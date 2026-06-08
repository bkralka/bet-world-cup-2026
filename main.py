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
from sqlalchemy import text, inspect
from pydantic import BaseModel, validator
from collections import defaultdict
import models
from database import engine, get_db
from typing import Optional


app = FastAPI(title="OnePick Cup 2026 API")
app.mount("/static", StaticFiles(directory="static"), name="static")
templates = Jinja2Templates(directory="templates")

ADMIN_SECRET = os.environ.get("ADMIN_SECRET", "change_me_in_env")

def ensure_columns():
    """Auto-migracja: dodaje brakujące kolumny do istniejących tabel.
    create_all() nie modyfikuje istniejących tabel, więc po dodaniu pola
    do modelu trzeba dorobić kolumnę ręcznie — to robi to automatycznie."""
    expected = {
        "players": [
            ("full_name", "VARCHAR"),
            ("favorite_team_points", "INTEGER DEFAULT 0"),
            ("star_player_points", "INTEGER DEFAULT 0"),
            ("current_streak", "INTEGER DEFAULT 0"),
            ("longest_streak", "INTEGER DEFAULT 0"),
            ("comeback_points", "INTEGER DEFAULT 0"),
            ("revival_used", "BOOLEAN DEFAULT FALSE"),
            ("favorite_locked", "BOOLEAN DEFAULT FALSE"),
            ("is_alive", "BOOLEAN DEFAULT TRUE"),
            ("shields", "INTEGER DEFAULT 2"),
        ],
        "matches": [
            ("scorers", "JSON DEFAULT '[]'::json"),
            ("multiplier", "INTEGER DEFAULT 1"),
            ("penalties", "VARCHAR"),
        ],
        "user_picks": [
            ("points_breakdown", "JSON"),
        ],
    }
    try:
        insp = inspect(engine)
        tables = insp.get_table_names()
        with engine.begin() as conn:
            for table, cols in expected.items():
                if table not in tables:
                    continue
                existing = {c["name"] for c in insp.get_columns(table)}
                for name, ddl in cols:
                    if name not in existing:
                        conn.execute(text(f'ALTER TABLE {table} ADD COLUMN {name} {ddl}'))
                        print(f"🔧 Dodano brakującą kolumnę {table}.{name}", flush=True)
    except Exception as e:
        print(f"⚠️ ensure_columns: {e}", flush=True)

@app.on_event("startup")
def startup_event():
    print("⏳ Otwieram port i próbuję połączyć się z bazą...", flush=True)
    try:
        models.Base.metadata.create_all(bind=engine)
        ensure_columns()
        print("⚽ CONNECTED TO DATABASE!", flush=True)
    except Exception as e:
        print(f"❌ BŁĄD BAZY DANYCH: {e}", flush=True)

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
    full_name: str = None

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
    penalties: Optional[str] = None

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

def streak_bonus(streak: int) -> int:
    """Bonus punktowy za serię trafień (naliczany przy osiągnięciu danej długości serii).
    3-6 → +1, 7-9 → +2, 10 → +3, 11 → +4, ... (rośnie o 1 za każdy kolejny od 10)."""
    if streak < 3:
        return 0
    if streak <= 6:
        return 1
    if streak <= 9:
        return 2
    return streak - 7  # 10→3, 11→4, 12→5, 13→6, 14→7, 15→8, ...

def now_utc():
    return datetime.now()

def get_upcoming_matches(db: Session, limit: int = 5):
    """Zwraca listę ID meczów, które są najbliższe (niezakończone, nie zablokowane, data > teraz)."""
    now = now_utc()
    matches = db.query(models.Match).filter(
        models.Match.is_finished == False,
        models.Match.is_locked == False,
        models.Match.match_date > now + timedelta(minutes=10)
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
            base_points = -1

        # 2. Bonus za wysoką liczbę bramek (tylko przy dokładnym wyniku)
        #    próg 4.5 bramki → +1 (czyli 5 goli), próg 5.5 bramki → +2 (czyli 6+ goli)
        high_score_bonus = 0
        if base_points == 3:
            if total_goals >= 6:
                high_score_bonus = 2
            elif total_goals >= 5:
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
            # Błędny typ: kara -1 plus bonusy (favorite, star), bez mnożenia
            total_points = base_points + favorite_bonus + star_player_bonus
        else:
            # Trafiony typ: punkty bazowe + bonusy (underdog, high_score, favorite) są mnożone,
            # bonus za gwiazdę dodawany osobno (nie podlega mnożeniu)
            total_points = int((base_points + high_score_bonus + underdog_bonus + favorite_bonus) * multiplier) + star_player_bonus

        return {
            "base_points": base_points,
            "high_score_bonus": high_score_bonus,
            "underdog_bonus": underdog_bonus,
            "favorite_bonus": favorite_bonus,
            "star_player_bonus": star_player_bonus,
            "multiplier": multiplier,
            "total_points": total_points
        }
    except Exception as e:
        print(f"Error calculating points: {e}")
        return {"total_points": 0, "base_points": 0, "high_score_bonus": 0, "underdog_bonus": 0, "favorite_bonus": 0, "star_player_bonus": 0, "multiplier": 1}

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
    matches = db.query(models.Match).filter(
        models.Match.is_finished == True,
        models.Match.stage == "group"
    ).all()

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
        "full_name": player.full_name,
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
        full_name=(auth.full_name.strip() if auth.full_name else None),
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

    # Mapa pozycji w grupie dla każdej drużyny, np. {"Meksyk": "1A", "Czechy": "2A"}
    team_positions = {}
    for group, teams in group_standings.items():
        for idx, t in enumerate(teams):
            team_positions[t["name"]] = f"{idx + 1}{group}"


    active_picks = []
    recent_picks = []
    if current_player:
        for pick in picks:
            if pick.player_id == current_player.id:
                match = db.query(models.Match).filter(models.Match.id == pick.match_id).first()
                if match and not match.is_finished:
                    active_picks.append(pick)
        # 5 ostatnich rozliczonych typów (najświeższe pierwsze)
        settled = db.query(models.UserPick).filter(
            models.UserPick.player_id == current_player.id
        ).join(models.Match).filter(models.Match.is_finished == True).order_by(models.Match.match_date.desc()).limit(5).all()
        recent_picks = settled

    return templates.TemplateResponse(
        request=request, name="index.html",
        context={
            "players": players, "matches": matches, "leaderboard": leaderboard,
            "all_players": all_players, "picks": picks,
            "current_player": current_player, "active_picks": active_picks,
            "recent_picks": recent_picks,
            "group_standings": group_standings, "knockout_bracket": knockout_bracket,
            "pick_stats": pick_stats, "now": now_utc, "timedelta": timedelta, "upcoming_match_ids": upcoming_match_ids,
            "team_positions": team_positions
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
    picks = db.query(models.UserPick).filter(models.UserPick.player_id == player_id).join(models.Match).order_by(models.Match.match_date.asc()).all()
    res = []
    for pick in picks:
        m = pick.match
        res.append({
            "match_date": m.match_date.isoformat(),
            "home_team": m.home_team,
            "away_team": m.away_team,
            "predicted_result": pick.predicted_result,
            "hidden": False,
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

    # Deadline: obstawianie zamyka się 10 minut przed pierwszym gwizdkiem
    if now_utc() >= match.match_date - timedelta(minutes=10):
        raise HTTPException(status_code=400, detail="Obstawianie zamknięte — zostało mniej niż 10 minut do meczu")

    # ----- NOWA LOGIKA: tylko pierwsze 4 nadchodzące mecze -----
    upcoming_ids = get_upcoming_matches(db, limit=5)
    if pick.match_id not in upcoming_ids:
        raise HTTPException(status_code=400, detail="Można typować tylko 5 najbliższych meczy (kolejność dat)")

    # Jeśli typ na ten mecz już istnieje → to EDYCJA, aktualizujemy bez limitu
    existing = db.query(models.UserPick).filter(
        models.UserPick.player_id == pick.player_id,
        models.UserPick.match_id == pick.match_id
    ).first()

    if existing:
        existing.predicted_result = pick.predicted_result
        db.commit()
        return existing

    # NOWY typ — sprawdź limit 5 meczów z bieżącej puli
    user_picks_count = db.query(models.UserPick).filter(
        models.UserPick.player_id == pick.player_id,
        models.UserPick.match_id.in_(upcoming_ids)
    ).count()
    if user_picks_count >= 5:
        raise HTTPException(status_code=400, detail="Możesz obstawić maksymalnie 5 meczy (wszystkie już wybrane)")

    new_pick = models.UserPick(player_id=pick.player_id, match_id=pick.match_id, predicted_result=pick.predicted_result)
    db.add(new_pick)
    db.commit()
    return new_pick

KO_DATES = {
    "round_32": datetime(2026, 6, 29, 18, 0),
    "round_16": datetime(2026, 7, 4, 18, 0),
    "quarter": datetime(2026, 7, 9, 18, 0),
    "semi": datetime(2026, 7, 14, 18, 0),
    "third_place": datetime(2026, 7, 18, 18, 0),
    "final": datetime(2026, 7, 19, 18, 0),
}

def _ko_winner(match):
    """Zwycięzca meczu pucharowego. Przy remisie po 90 min decydują karne (pole penalties)."""
    if not match.result: return None
    h, a = map(int, match.result.split(":"))
    if h > a: return match.home_team
    if a > h: return match.away_team
    # remis — rozstrzygają karne
    if match.penalties:
        try:
            ph, pa = map(int, match.penalties.split(":"))
            return match.home_team if ph > pa else match.away_team
        except (ValueError, AttributeError):
            return None
    return None  # remis bez karnych — nie można wyłonić zwycięzcy

def _ko_loser(match):
    if not match.result: return None
    w = _ko_winner(match)
    if not w: return None
    return match.away_team if w == match.home_team else match.home_team

def _ko_create(db, home, away, stage, when):
    """Tworzy mecz pucharowy, jeśli jeszcze nie istnieje (idempotentne)."""
    exists = db.query(models.Match).filter(
        models.Match.stage == stage,
        models.Match.home_team == home,
        models.Match.away_team == away
    ).first()
    if exists: return exists
    m = models.Match(home_team=home, away_team=away, match_date=when, stage=stage,
                     multiplier=STAGE_MULTIPLIERS.get(stage, 1), is_locked=False, is_finished=False, result=None)
    db.add(m); db.commit()
    return m

def _qualified_32(db):
    """32 drużyny awansujące: 12 zwycięzców grup + 12 wicemistrzów + 8 najlepszych z 3. miejsc."""
    standings = calculate_group_standings(db)
    qualified = []   # (team, group, pos)
    thirds = []
    for g in GROUPS_LIST:
        teams = standings.get(g, [])
        for pos in (1, 2):
            if len(teams) >= pos:
                qualified.append((teams[pos-1]["name"], g, pos))
        if len(teams) >= 3:
            t = teams[2]
            thirds.append((t["name"], g, t["points"], t["goal_diff"], t["goals_for"]))
    thirds.sort(key=lambda x: (x[2], x[3], x[4]), reverse=True)
    for name, g, *_ in thirds[:8]:
        qualified.append((name, g, 3))
    return qualified

def advance_tournament_if_ready(db):
    """Automatycznie tworzy kolejną rundę, gdy poprzednia jest w całości rozegrana.
    Wywoływane po każdym wprowadzeniu wyniku — dzięki temu drabinka buduje się sama."""
    def all_done(stage):
        ms = db.query(models.Match).filter(models.Match.stage == stage).all()
        return bool(ms) and all(m.is_finished for m in ms)
    def has(stage):
        return db.query(models.Match).filter(models.Match.stage == stage).first() is not None
    def winners_of(stage):
        ms = db.query(models.Match).filter(models.Match.stage == stage, models.Match.is_finished == True).order_by(models.Match.match_date, models.Match.id).all()
        return [_ko_winner(m) for m in ms]

    # 1) Faza grupowa zakończona → utwórz 1/16 finału (oficjalny schemat MŚ 2026)
    if all_done("group") and not has("round_32"):
        q = _qualified_32(db)
        if len(q) >= 32:
            winners = {g: n for n, g, p in q if p == 1}
            runners = {g: n for n, g, p in q if p == 2}
            third_list = [(n, g) for n, g, p in q if p == 3]  # (drużyna, grupa) wg rankingu

            # Oficjalny klucz MŚ 2026:
            #  - zwycięzcy grup A,B,D,E,G,I,K,L grają z najlepszymi 3. miejscami
            #  - zwycięzcy C,F,H,J grają z wicemistrzami (krzyżowo)
            #  - pozostali wicemistrzowie grają parami
            winner_third_slots = ["A", "B", "D", "E", "G", "I", "K", "L"]
            wr_pairs = [("C", "F"), ("F", "C"), ("H", "J"), ("J", "H")]   # zwycięzca vs wicemistrz
            rr_pairs = [("A", "B"), ("E", "I"), ("D", "G"), ("K", "L")]   # wicemistrz vs wicemistrz

            pairs = []
            used = set()
            # zwycięzca vs wicemistrz
            for wg, rg in wr_pairs:
                t1, t2 = winners.get(wg), runners.get(rg)
                if t1 and t2 and t1 not in used and t2 not in used:
                    pairs.append((t1, t2)); used.add(t1); used.add(t2)
            # wicemistrz vs wicemistrz
            for rg1, rg2 in rr_pairs:
                t1, t2 = runners.get(rg1), runners.get(rg2)
                if t1 and t2 and t1 not in used and t2 not in used:
                    pairs.append((t1, t2)); used.add(t1); used.add(t2)
            # zwycięzca vs 3. miejsce (przypisanie unikające tej samej grupy)
            for wg in winner_third_slots:
                w_team = winners.get(wg)
                if not w_team or w_team in used:
                    continue
                chosen = None
                for tn, tg in third_list:
                    if tn not in used and tg != wg:
                        chosen = tn; break
                if chosen:
                    pairs.append((w_team, chosen)); used.add(w_team); used.add(chosen)

            base = KO_DATES["round_32"]
            for i, (home, away) in enumerate(pairs):
                _ko_create(db, home, away, "round_32", base + timedelta(days=i//4, hours=(i%4)*3))

    # 2) Kolejne rundy — buduj/aktualizuj na bieżąco: zwycięzca rozstrzygniętego meczu
    #    od razu trafia do następnej rundy, nierozstrzygnięte miejsca pokazują "—".
    TBD = "—"
    def slot_winner(m):
        return _ko_winner(m) or TBD

    for stage, nxt in [("round_32", "round_16"), ("round_16", "quarter"), ("quarter", "semi")]:
        if not has(stage):
            continue
        prev = db.query(models.Match).filter(models.Match.stage == stage).order_by(models.Match.match_date, models.Match.id).all()
        n_pairs = len(prev) // 2
        if n_pairs == 0:
            continue
        existing = db.query(models.Match).filter(models.Match.stage == nxt).order_by(models.Match.match_date, models.Match.id).all()
        base = KO_DATES[nxt]
        for i in range(n_pairs):
            home = slot_winner(prev[2*i])
            away = slot_winner(prev[2*i+1])
            if i < len(existing):
                nm = existing[i]
                if not nm.is_finished:  # nie nadpisuj już rozegranego meczu
                    nm.home_team = home
                    nm.away_team = away
            else:
                db.add(models.Match(home_team=home, away_team=away, match_date=base + timedelta(days=i//2),
                                    stage=nxt, multiplier=STAGE_MULTIPLIERS.get(nxt, 1), is_locked=False, is_finished=False, result=None))
        db.commit()

    # 3) Półfinały → finał + mecz o 3. miejsce (też na bieżąco)
    if has("semi"):
        sm = db.query(models.Match).filter(models.Match.stage == "semi").order_by(models.Match.match_date, models.Match.id).all()
        if len(sm) >= 2:
            fh, fa = slot_winner(sm[0]), slot_winner(sm[1])
            lh, la = (_ko_loser(sm[0]) or TBD), (_ko_loser(sm[1]) or TBD)
            ef = db.query(models.Match).filter(models.Match.stage == "final").first()
            if ef:
                if not ef.is_finished:
                    ef.home_team, ef.away_team = fh, fa
            else:
                db.add(models.Match(home_team=fh, away_team=fa, match_date=KO_DATES["final"], stage="final",
                                    multiplier=STAGE_MULTIPLIERS.get("final", 3), is_locked=False, is_finished=False, result=None))
            et = db.query(models.Match).filter(models.Match.stage == "third_place").first()
            if et:
                if not et.is_finished:
                    et.home_team, et.away_team = lh, la
            else:
                db.add(models.Match(home_team=lh, away_team=la, match_date=KO_DATES["third_place"], stage="third_place",
                                    multiplier=STAGE_MULTIPLIERS.get("third_place", 2), is_locked=False, is_finished=False, result=None))
            db.commit()

    db.commit()

@app.post("/admin/advance", dependencies=[Depends(verify_admin)])
def admin_advance(db: Session = Depends(get_db)):
    """Ręcznie wyzwala budowę kolejnej rundy + zwraca diagnostykę, co blokuje awans."""
    group_total = db.query(models.Match).filter(models.Match.stage == "group").count()
    group_done = db.query(models.Match).filter(models.Match.stage == "group", models.Match.is_finished == True).count()
    q = _qualified_32(db)
    before = db.query(models.Match).filter(models.Match.stage == "round_32").count()
    advance_tournament_if_ready(db)
    after = db.query(models.Match).filter(models.Match.stage == "round_32").count()

    # tabela grup — ile drużyn w każdej (do diagnozy)
    standings = calculate_group_standings(db)
    groups_sizes = {g: len(standings.get(g, [])) for g in GROUPS_LIST}
    incomplete = [g for g, n in groups_sizes.items() if n < 4]

    return {
        "status": "ok",
        "mecze_grupowe_lacznie": group_total,
        "mecze_grupowe_rozegrane": group_done,
        "wszystkie_grupowe_rozegrane": group_total > 0 and group_total == group_done,
        "zakwalifikowanych_druzyn": len(q),
        "round_32_przed": before,
        "round_32_po": after,
        "grupy_niekompletne": incomplete,
    }

@app.put("/matches/{match_id}/result", dependencies=[Depends(verify_admin)])
def update_match_result(match_id: int, result: MatchResultUpdate, db: Session = Depends(get_db)):
    match = db.query(models.Match).filter(models.Match.id == match_id).first()
    if not match: raise HTTPException(status_code=404)

    was_finished = match.is_finished  # czy to korekta już rozliczonego meczu

    match.result = result.result
    match.scorers = result.scorers
    match.penalties = result.penalties
    match.is_finished = True
    match.is_locked = True
    db.commit()

    picks = db.query(models.UserPick).filter(models.UserPick.match_id == match_id).all()

    for pick in picks:
        player = db.query(models.Player).filter(models.Player.id == pick.player_id).first()
        if not player: continue

        pd = calculate_points_with_bonus(
            pick.predicted_result, result.result, match.stage,
            match.home_team, match.away_team, player.favorite_team,
            player.star_player, result.scorers
        )
        match_total = pd["total_points"]   # punkty za sam typ (z bonusami meczowymi)

        if was_finished:
            # KOREKTA — cofnij poprzedni wynik meczowy, dolicz nowy (serii nie ruszamy)
            player.total_points += (match_total - (pick.points_earned or 0))
            pick.points_earned = match_total
            bd = dict(pick.points_breakdown or {})
            bd.update({"base": pd["base_points"], "high_score": pd["high_score_bonus"], "underdog": pd["underdog_bonus"],
                       "favorite": pd["favorite_bonus"], "star": pd["star_player_bonus"],
                       "multiplier": pd["multiplier"], "match_total": match_total})
            pick.points_breakdown = bd
        else:
            # PIERWSZE rozliczenie
            pick.points_earned = match_total
            player.total_points += match_total
            player.favorite_team_points += pd["favorite_bonus"]
            player.star_player_points += pd["star_player_bonus"]
            sb = 0
            if pd["base_points"] > 0:
                player.correct_predictions += 1
                player.current_streak += 1
                if player.current_streak > player.longest_streak:
                    player.longest_streak = player.current_streak
                sb = streak_bonus(player.current_streak)   # bonus za serię
                if sb > 0:
                    player.total_points += sb
            else:
                player.current_streak = 0
            pick.points_breakdown = {
                "base": pd["base_points"], "high_score": pd["high_score_bonus"], "underdog": pd["underdog_bonus"],
                "favorite": pd["favorite_bonus"], "star": pd["star_player_bonus"], "multiplier": pd["multiplier"],
                "streak_bonus": sb, "streak_len": player.current_streak,
                "match_total": match_total, "grand_total": match_total + sb
            }

        db.commit()

    # Automatyczne tworzenie kolejnej rundy, gdy bieżąca jest rozegrana
    advance_tournament_if_ready(db)

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
    player = db.query(models.Player).filter(models.Player.id == player_id).first()
    star = player.star_player if player else None
    # Sortowanie malejące — najświeższe mecze na górze
    picks = db.query(models.UserPick).filter(models.UserPick.player_id == player_id).join(models.Match).order_by(models.Match.match_date.desc()).all()
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
            "penalties": match.penalties if match.is_finished else None,
            "scorers": match.scorers or [],
            "star_player": star,
            "stage": match.stage,
            "points_earned": pick.points_earned,
            "breakdown": pick.points_breakdown or None,
            "is_finished": match.is_finished,
        })
    return history



# ========================================================
# PANEL ADMINISTRATORA (WIDOK + OBSŁUGA)
# ========================================================
from fastapi.responses import HTMLResponse

@app.get("/admin", response_class=HTMLResponse)
def admin_panel(request: Request, db: Session = Depends(get_db)):
    players = db.query(models.Player).order_by(models.Player.total_points.desc()).all()
    matches = db.query(models.Match).order_by(models.Match.match_date.asc()).all()
    
    # Budowanie wierszy tabeli graczy
    players_html = ""
    for p in players:
        status = '<span class="text-green-400 bg-green-500/10 px-2 py-0.5 rounded text-xs font-medium">W grze</span>' if p.is_alive else '<span class="text-red-400 bg-red-500/10 px-2 py-0.5 rounded text-xs font-medium">Odpadł</span>'
        players_html += f"""
        <tr class="border-b border-white/5 hover:bg-white/[0.02] text-sm transition">
            <td class="p-3 font-semibold text-white">{p.username}</td>
            <td class="p-3 text-amber-400 font-bold">{p.total_points} pkt</td>
            <td class="p-3 font-medium text-xs text-gray-300 truncate max-w-[140px]">{p.full_name or '-'}</td>
            <td class="p-3 font-medium text-xs text-gray-400 truncate max-w-[120px]">{p.star_player or '-'}</td>
            <td class="p-3 font-medium text-xs text-gray-400 truncate max-w-[120px]">{p.favorite_team or '-'}</td>
            <td class="p-3 text-right">{status}</td>
        </tr>
        """

    # Budowanie kafelków z meczami
    matches_html = ""
    for m in matches:
        scorers_val = ", ".join(m.scorers) if m.scorers else ""
        is_ko = m.stage != "group"
        pen_finished = f'<input type="text" id="pen-{m.id}" value="{m.penalties or ""}" placeholder="Karne np. 4:3 (przy remisie)" class="w-full bg-[#1a1e26] border border-amber-500/30 rounded-lg px-2.5 py-1 text-xs text-amber-300 focus:outline-none focus:border-amber-500">' if is_ko else ""
        pen_pending = f'<input type="text" id="pen-{m.id}" placeholder="Karne np. 4:3 (przy remisie)" class="w-full bg-[#1a1e26] border border-amber-500/30 rounded-lg px-2.5 py-1 text-xs text-amber-300 focus:outline-none focus:border-amber-500">' if is_ko else ""
        if m.is_finished:
            pen_label = f' &nbsp;·&nbsp; karne {m.penalties}' if m.penalties else ''
            status_badge = f'<span class="text-gray-400 bg-white/5 px-2 py-0.5 rounded text-xs font-medium">Zakończony ({m.result}{pen_label})</span>'
            action_fields = f"""
            <div class="flex flex-col gap-2 mt-2 pt-2 border-t border-white/5">
                <p class="text-[11px] text-gray-500 italic">Popraw wynik / bramki:</p>
                <div class="flex gap-2">
                    <input type="text" id="res-{m.id}" value="{m.result or ''}" placeholder="Wynik np. 2:1" class="w-24 bg-[#1a1e26] border border-white/10 rounded-lg px-2.5 py-1 text-xs text-white focus:outline-none focus:border-amber-500">
                    <input type="text" id="sc-{m.id}" value="{scorers_val}" placeholder="Strzelcy (np. Mbappe, Neymar)" class="flex-1 bg-[#1a1e26] border border-white/10 rounded-lg px-2.5 py-1 text-xs text-white focus:outline-none focus:border-amber-500">
                </div>
                {pen_finished}
                <button onclick="saveMatch({m.id})" class="w-full bg-white/10 hover:bg-white/20 text-white font-bold text-xs py-1.5 rounded-lg transition">Zaktualizuj wynik</button>
            </div>
            """
        else:
            status_badge = '<span class="text-amber-400 bg-amber-500/10 px-2 py-0.5 rounded text-xs font-medium">Oczekuje</span>'
            action_fields = f"""
            <div class="flex flex-col gap-2 mt-2 pt-2 border-t border-white/5">
                <div class="flex gap-2">
                    <input type="text" id="res-{m.id}" placeholder="Wynik np. 2:1" class="w-24 bg-[#1a1e26] border border-white/10 rounded-lg px-2.5 py-1 text-xs text-white focus:outline-none focus:border-amber-500">
                    <input type="text" id="sc-{m.id}" placeholder="Strzelcy (np. Mbappe, Neymar)" class="flex-1 bg-[#1a1e26] border border-white/10 rounded-lg px-2.5 py-1 text-xs text-white focus:outline-none focus:border-amber-500">
                </div>
                {pen_pending}
                <button onclick="saveMatch({m.id})" class="w-full bg-amber-500 hover:bg-amber-600 text-gray-900 font-bold text-xs py-1.5 rounded-lg transition shadow-md">Zatwierdź i Rozlicz Punkty</button>
            </div>
            """
        
        date_str = m.match_date.strftime("%d.%m %H:%M") if m.match_date else ""
        matches_html += f"""
        <div class="p-4 rounded-xl border border-white/5 bg-[#14171d] flex flex-col justify-between gap-1 shadow-sm">
            <div class="flex items-center justify-between border-b border-white/5 pb-1.5 mb-1">
                <span class="text-[10px] font-mono text-gray-500">{date_str} &nbsp;(ID: {m.id})</span>
                {status_badge}
            </div>
            <div class="text-sm font-semibold text-white py-0.5">
                {m.home_team} <span class="text-amber-500/60 px-0.5 text-xs font-normal">vs</span> {m.away_team}
            </div>
            {action_fields}
        </div>
        """

    html_content = f"""
    <!DOCTYPE html>
    <html lang="pl">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Panel Administratora — Bet World Cup</title>
        <script src="https://cdn.tailwindcss.com"></script>
        <style>
            body {{ background-color: #0b0d11; color: #94a3b8; font-family: system-ui, sans-serif; }}
            ::-webkit-scrollbar {{ width: 6px; }}
            ::-webkit-scrollbar-thumb {{ background: rgba(255,255,255,0.05); border-radius: 10px; }}
        </style>
    </head>
    <body class="p-4 md:p-8">
        <div class="max-w-6xl mx-auto">
            
            <div class="flex flex-wrap items-center justify-between border-b border-white/10 pb-4 mb-6 gap-4">
                <div>
                    <h1 class="text-2xl font-bold text-white tracking-tight">⚙️ Panel Zarządzania Typerem</h1>
                    <p class="text-xs text-gray-500 mt-0.5">Rozliczanie meczów turniejowych i podgląd tabeli na żywo</p>
                </div>
                <div class="flex items-center gap-2 bg-[#14171d] p-1.5 rounded-xl border border-white/5">
                    <input type="password" id="admin-secret-input" placeholder="Wpisz Twój ADMIN_SECRET" class="bg-[#1a1e26] border border-white/5 rounded-lg px-3 py-1.5 text-xs text-white focus:outline-none focus:border-amber-500 w-48">
                    <button onclick="saveSecret()" class="bg-amber-500 hover:bg-amber-600 text-gray-900 text-xs font-bold px-3 py-1.5 rounded-lg transition shadow">Autoryzuj</button>
                    <button onclick="buildKnockout()" class="bg-emerald-600 hover:bg-emerald-700 text-white text-xs font-bold px-3 py-1.5 rounded-lg transition shadow">🏆 Zbuduj fazę pucharową</button>
                </div>
            </div>

            <div class="grid grid-cols-1 lg:grid-cols-3 gap-6">
                
                <div class="lg:col-span-2 space-y-4">
                    <div class="bg-[#14171d] border border-white/5 rounded-2xl p-4 shadow-xl">
                        <div class="flex items-center justify-between mb-4 border-b border-white/5 pb-2">
                            <h2 class="text-xs font-bold uppercase tracking-wider text-gray-400">👥 Lista Graczy w bazie</h2>
                            <span class="text-[10px] font-mono bg-white/5 px-2 py-0.5 rounded text-gray-400">{len(players)} zarejestrowanych</span>
                        </div>
                        <div class="overflow-x-auto">
                            <table class="w-full text-left border-collapse">
                                <thead>
                                    <tr class="border-b border-white/10 text-xs uppercase tracking-wider text-gray-500">
                                        <th class="p-3 font-semibold">Gracz</th>
                                        <th class="p-3 font-semibold">Punkty</th>
                                        <th class="p-3 font-semibold">Imię i nazwisko</th>
                                        <th class="p-3 font-semibold">Gwiazda</th>
                                        <th class="p-3 font-semibold">Zespół</th>
                                        <th class="p-3 font-semibold text-right">Status</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    {players_html}
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>

                <div class="space-y-4">
                    <div class="bg-[#14171d] border border-white/5 rounded-2xl p-4 shadow-xl">
                        <h2 class="text-xs font-bold uppercase tracking-wider text-gray-400 mb-4 border-b border-white/5 pb-2">⚽ Rozliczanie Terminarza</h2>
                        <div class="space-y-3 max-h-[75vh] overflow-y-auto pr-1">
                            {matches_html}
                        </div>
                    </div>
                </div>

            </div>
        </div>

        <script>
            // Automatyczne załadowanie klucza z pamięci przeglądarki przy starcie
            document.addEventListener('DOMContentLoaded', () => {{
                const savedSecret = localStorage.getItem('app_admin_secret');
                if (savedSecret) {{
                    document.getElementById('admin-secret-input').value = savedSecret;
                }}
            }});

            function saveSecret() {{
                const val = document.getElementById('admin-secret-input').value.trim();
                if(!val) return alert('Wpisz sekretny klucz!');
                localStorage.setItem('app_admin_secret', val);
                alert('Klucz autoryzacyjny został zapisany w przeglądarce!');
            }}

            async function buildKnockout() {{
                const secret = document.getElementById('admin-secret-input').value.trim();
                if (!secret) {{ alert('Najpierw podaj ADMIN_SECRET!'); return; }}
                if (!confirm('Zbudować/odświeżyć fazę pucharową na podstawie wyników? (bezpieczne — nie nadpisuje istniejących meczów)')) return;
                try {{
                    const r = await fetch('/admin/advance', {{ method: 'POST', headers: {{ 'x-admin-secret': secret }} }});
                    if (r.ok) {{ alert('Gotowe! Drabinka zaktualizowana. Sprawdź zakładkę Drabinka.'); location.reload(); }}
                    else {{ const e = await r.json(); alert('Błąd: ' + JSON.stringify(e.detail || e)); }}
                }} catch (err) {{ alert('Błąd połączenia: ' + err); }}
            }}

            async function saveMatch(matchId) {{
                const secret = document.getElementById('admin-secret-input').value.trim();
                if (!secret) {{
                    alert('Błąd: Musisz podać ADMIN_SECRET w polu na górze strony!');
                    return;
                }}

                const resultString = document.getElementById('res-' + matchId).value.trim();
                const scorersString = document.getElementById('sc-' + matchId).value.trim();
                const penEl = document.getElementById('pen-' + matchId);
                const penString = penEl ? penEl.value.trim() : '';

                if (!resultString) {{
                    alert('Błąd: Musisz podać ostateczny wynik (np. 1:0)!');
                    return;
                }}

                // W fazie pucharowej remis wymaga karnych (żeby wyłonić zwycięzcę)
                if (penEl) {{
                    const rp = resultString.split(':');
                    if (rp.length === 2 && rp[0].trim() === rp[1].trim() && !penString) {{
                        alert('To mecz pucharowy i jest remis — podaj wynik karnych (np. 4:3), żeby wyłonić zwycięzcę.');
                        return;
                    }}
                }}

                // Zamiana strzelców po przecinku na czystą tablicę JSON
                const scorersArray = scorersString ? scorersString.split(',').map(s => s.trim()).filter(s => s.length > 0) : [];

                if (!confirm('Czy na pewno chcesz zapisać wynik ' + resultString + (penString ? ' (karne ' + penString + ')' : '') + ' dla meczu o ID: ' + matchId + '? System automatycznie przeliczy punkty wszystkim graczom.')) return;

                try {{
                    const response = await fetch('/matches/' + matchId + '/result', {{
                        method: 'PUT',
                        headers: {{
                            'Content-Type': 'application/json',
                            'x-admin-secret': secret
                        }},
                        body: JSON.stringify({{
                            result: resultString,
                            scorers: scorersArray,
                            penalties: penString || null
                        }})
                    }});

                    if (response.ok) {{
                        alert('Sukces! Wynik wprowadzony, punkty przyznane.');
                        location.reload();
                    }} else {{
                        const errData = await response.json();
                        alert('Błąd serwera: ' + (errData.detail || 'Niepoprawny ADMIN_SECRET lub błąd danych.'));
                    }}
                }} catch (err) {{
                    alert('Błąd połączenia sieciowego: ' + err.message);
                }}
            }}
        </script>
    </body>
    </html>
    """
    return html_content