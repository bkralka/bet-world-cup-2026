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
from sqlalchemy.exc import IntegrityError
from pydantic import BaseModel, validator
from collections import defaultdict, Counter
import models
from database import engine, get_db
from typing import Optional


app = FastAPI(title="OnePick Cup 2026 API")
app.mount("/static", StaticFiles(directory="static"), name="static")
templates = Jinja2Templates(directory="templates")

@app.middleware("http")
async def no_cache_for_dynamic_pages(request: Request, call_next):
    """Blokuje cache'owanie stron z danymi użytkownika, żeby nikt nie zobaczył
    konta innego gracza zapisanego w cache przeglądarki/pośrednika.
    Pliki statyczne (/static) mogą być normalnie cache'owane."""
    response = await call_next(request)
    if not request.url.path.startswith("/static"):
        response.headers["Cache-Control"] = "no-store, no-cache, must-revalidate, private, max-age=0"
        response.headers["Pragma"] = "no-cache"
        response.headers["Expires"] = "0"
        response.headers["Vary"] = "Cookie"
    return response

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
            ("scorer_teams", "JSON DEFAULT '[]'::json"),
            ("scorer_minutes", "JSON DEFAULT '[]'::json"),
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

def ensure_pick_uniqueness():
    """Usuwa zduplikowane typy (ten sam gracz + mecz) i zakłada unikalny indeks,
    żeby duplikaty nie mogły już powstać (np. przez podwójne kliknięcie / race condition).
    Zostawiamy najnowszy typ (największe id) dla każdej pary (player_id, match_id)."""
    try:
        insp = inspect(engine)
        if "user_picks" not in insp.get_table_names():
            return
        with engine.begin() as conn:
            # 1) Usuń duplikaty — zostaw najnowszy wpis na parę (gracz, mecz)
            res = conn.execute(text("""
                DELETE FROM user_picks
                WHERE id NOT IN (
                    SELECT MAX(id) FROM user_picks GROUP BY player_id, match_id
                )
            """))
            removed = res.rowcount if res.rowcount is not None else 0
            # 2) Załóż unikalny indeks (idempotentnie) — twardo blokuje przyszłe duplikaty
            conn.execute(text("""
                CREATE UNIQUE INDEX IF NOT EXISTS uq_user_picks_player_match
                ON user_picks (player_id, match_id)
            """))
        if removed:
            print(f"🔒 user_picks: usunięto {removed} zduplikowanych typów", flush=True)
        print("🔒 user_picks: unikalny indeks (player_id, match_id) zapewniony", flush=True)
    except Exception as e:
        print(f"⚠️ ensure_pick_uniqueness: {e}", flush=True)

@app.on_event("startup")
def startup_event():
    print("⏳ Otwieram port i próbuję połączyć się z bazą...", flush=True)
    try:
        models.Base.metadata.create_all(bind=engine)
        ensure_columns()
        ensure_pick_uniqueness()
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
    scorer_teams: List[str] = []
    scorer_minutes: List[Optional[str]] = []
    penalties: Optional[str] = None

    @validator('result')
    def validate_result_format(cls, v):
        if not re.match(r'^\d{1,2}:\d{1,2}$', v):
            raise ValueError('Wynik musi być w formacie "X:Y"')
        return v

    @validator('penalties')
    def validate_penalties_format(cls, v):
        if v and not re.match(r'^\d{1,2}:\d{1,2}$', v):
            raise ValueError('Wynik karnych musi być w formacie "X:Y", np. "4:3"')
        return v

class FavoriteTeamUpdate(BaseModel):
    favorite_team: str = None
    star_player: str = None

UNDERDOG_TEAMS = {
    "Haiti", "Curacao", "RPA", "Bośnia i Hercegowina",
    "Nowa Zelandia", "Arabia Saudyjska", "RZP", "Irak",
    "Jordania", "Uzbekistan", "DR Konga", "Panama"
}

STAGE_MULTIPLIERS = {
    "group": 1,
    "round_32": 1,
    "round_16": 2,
    "quarter": 2,
    "semi": 3,
    "final": 4
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
    """Aktualny czas w strefie polskiej (Europe/Warsaw), jako naive datetime.
    Daty meczów są wpisywane w czasie polskim, więc wszystko liczy się spójnie —
    niezależnie od tego, czy serwer (Render/Docker) działa w UTC."""
    try:
        from zoneinfo import ZoneInfo
        return datetime.now(ZoneInfo("Europe/Warsaw")).replace(tzinfo=None)
    except Exception:
        # awaryjnie: czas letni w Polsce to UTC+2 (turniej rozgrywany jest latem)
        return datetime.now(timezone.utc).replace(tzinfo=None) + timedelta(hours=2)

def get_upcoming_matches(db: Session, limit: int = 8):
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
            base_points = 3  # dokładny wynik
        elif (pred_h > pred_a and act_h > act_a) or (pred_h < pred_a and act_h < act_a) or (pred_h == pred_a and act_h == act_a):
            base_points = 1  # dobry kierunek (trafiony zwycięzca lub trafiony remis)
        elif pred_h == pred_a or act_h == act_a:
            base_points = 0  # remis w typie LUB w wyniku — remis nigdy nie zabiera punktu (bez kary)
        else:
            base_points = -1  # obstawiłeś wygraną jednej drużyny, a wygrała druga

        # 2. Bonus za wysoką liczbę bramek
        #    Poziom bonusu wyznacza TWÓJ TYP (ile goli obstawiłeś), a WYNIK musi osiągnąć ten próg:
        #    - typ ma ≥6 goli ("over 5,5") → +2, ale tylko gdy w meczu padło też ≥6 goli (inaczej 0),
        #    - typ ma 5 goli ("over 4,5") → +1, gdy w meczu padło ≥5 goli.
        #    Działa tylko przy trafionym kierunku (base_points >= 1).
        pred_goals = pred_h + pred_a
        high_score_bonus = 0
        if base_points >= 1:
            if pred_goals >= 6:
                if total_goals >= 6:
                    high_score_bonus = 2
            elif pred_goals >= 5:
                if total_goals >= 5:
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

# Kody flag (port z FLAG_CODES w index.html) — do renderowania flag po stronie serwera.
TEAM_FLAG_CODES = {
    "Meksyk": "mx", "Korea Południowa": "kr", "RPA": "za", "Czechy": "cz",
    "Kanada": "ca", "Szwajcaria": "ch", "Katar": "qa", "Bośnia i Hercegowina": "ba",
    "Brazylia": "br", "Maroko": "ma", "Szkocja": "gb-sct", "Haiti": "ht",
    "USA": "us", "Australia": "au", "Paragwaj": "py", "Turcja": "tr",
    "Niemcy": "de", "Ekwador": "ec", "WKS": "ci", "Curacao": "cw",
    "Holandia": "nl", "Japonia": "jp", "Tunezja": "tn", "Szwecja": "se",
    "Belgia": "be", "Iran": "ir", "Egipt": "eg", "Nowa Zelandia": "nz",
    "Hiszpania": "es", "Urugwaj": "uy", "Arabia Saudyjska": "sa", "RZP": "cv",
    "Francja": "fr", "Senegal": "sn", "Norwegia": "no", "Irak": "iq",
    "Argentyna": "ar", "Austria": "at", "Algieria": "dz", "Jordania": "jo",
    "Portugalia": "pt", "Kolumbia": "co", "Uzbekistan": "uz", "DR Konga": "cd",
    "Anglia": "gb-eng", "Chorwacja": "hr", "Panama": "pa", "Ghana": "gh"
}

# Wpisy traktowane jako gol samobójczy — NIE liczą się do klasyfikacji strzelców.
OWN_GOAL_ALIASES = {"samobój", "samoboj", "samobója", "samobojka", "og", "own goal"}

def is_own_goal(name) -> bool:
    return (name or "").strip().lower() in OWN_GOAL_ALIASES

def _minute_sort_key(minute):
    """Klucz sortowania: "45+2" -> 45.02, "12" -> 12, brak -> na koniec."""
    if not minute:
        return 9999.0
    s = str(minute).strip().replace("'", "")
    if "+" in s:
        base, _, extra = s.partition("+")
        try:
            return int(base) + (int(extra or 0) / 100.0)
        except ValueError:
            return 9999.0
    try:
        return float(int(s))
    except ValueError:
        return 9999.0

def build_goal_timeline(m):
    """Chronologiczna lista goli meczu: [{name, team, flag_code, minute, is_own_goal}]."""
    sc = m.scorers or []
    st = m.scorer_teams or []
    mins = m.scorer_minutes or []
    goals = []
    for i, name in enumerate(sc):
        nm = (name or "").strip()
        if not nm:
            continue
        team = st[i] if i < len(st) else None
        minute = mins[i] if i < len(mins) else None
        og = is_own_goal(nm)
        goals.append({
            "name": nm,
            "team": None if og else team,
            "flag_code": (TEAM_FLAG_CODES.get(team) if (team and not og) else None),
            "minute": minute,
            "is_own_goal": og,
            "_sort": _minute_sort_key(minute),
        })
    goals.sort(key=lambda g: g["_sort"])
    return goals

def build_goal_sides(m):
    """Gole jako jedna lista posortowana po minucie, każdy z oznaczeniem strony.
    Zwraca {'rows': [{name, minute, is_own_goal, side}], 'has_sides': bool}.
    side: 'home' | 'away' | 'unknown' (stare dane bez kraju)."""
    sc = m.scorers or []
    st = m.scorer_teams or []
    mins = m.scorer_minutes or []
    rows = []
    has_sides = False
    for i, name in enumerate(sc):
        nm = (name or "").strip()
        if not nm:
            continue
        minute = mins[i] if i < len(mins) else None
        team = st[i] if i < len(st) else None
        if team == m.home_team:
            side = "home"; has_sides = True
        elif team == m.away_team:
            side = "away"; has_sides = True
        else:
            side = "unknown"
        rows.append({
            "name": nm,
            "minute": minute,
            "is_own_goal": is_own_goal(nm),
            "side": side,
            "_sort": _minute_sort_key(minute),
        })
    rows.sort(key=lambda g: g["_sort"])
    return {"rows": rows, "has_sides": has_sides}

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

def calculate_third_place_ranking(db: Session):
    """Klasyfikacja drużyn z 3. miejsca (format WC 2026: awansuje 8 najlepszych z 12).
    Kryteria FIFA, po kolei: punkty -> różnica bramek -> bramki zdobyte.
    (Dalsze kryteria — fair-play, ranking FIFA — nie są tu liczone, bo brak danych.)"""
    standings = calculate_group_standings(db)
    thirds = []
    for group in GROUPS_LIST:
        teams = standings.get(group, [])
        if len(teams) >= 3:
            t = dict(teams[2])          # 3. miejsce w grupie
            t["group"] = group
            thirds.append(t)

    thirds.sort(key=lambda x: (x["points"], x["goal_diff"], x["goals_for"]), reverse=True)
    for i, t in enumerate(thirds):
        t["rank"] = i + 1
        t["advances"] = i < 8           # 8 najlepszych awansuje
    return thirds

def calculate_top_scorers(db: Session):
    """Lista strzelców z ręcznie wpisywanych Match.scorers (każde wystąpienie = 1 gol).
    Reprezentacja jest zgadywana z części wspólnej drużyn meczów, w których strzelał —
    pokazywana tylko gdy jednoznaczna."""
    matches = db.query(models.Match).filter(models.Match.is_finished == True).all()
    goals = defaultdict(int)
    team_sets = defaultdict(list)       # strzelec -> lista zbiorów {gosp, gość} z jego meczów (fallback)
    explicit_team = {}                  # strzelec -> kraj wpisany wprost w panelu (priorytet)

    for m in matches:
        if not m.scorers:
            continue
        sc = m.scorers
        st = m.scorer_teams or []
        has_teams = len(st) == len(sc)   # czy mamy równoległą listę krajów
        match_teams = {m.home_team, m.away_team}
        for idx, name in enumerate(sc):
            key = (name or "").strip()
            if not key or is_own_goal(key):     # samobóje nie liczą się do strzelców
                continue
            goals[key] += 1
            if has_teams and st[idx]:
                explicit_team[key] = st[idx]    # jawny kraj — nadpisuje
            team_sets[key].append(match_teams)

    scorers = []
    for name, count in goals.items():
        team = explicit_team.get(name)          # 1) kraj wpisany w panelu
        if not team:                            # 2) fallback: część wspólna meczów
            sets = team_sets[name]
            if sets:
                common = set.intersection(*sets)
                if len(common) == 1:
                    team = next(iter(common))
        scorers.append({
            "name": name,
            "goals": count,
            "team": team,
            "flag_code": TEAM_FLAG_CODES.get(team) if team else None,
        })

    scorers.sort(key=lambda x: x["name"].lower())          # alfabetycznie...
    scorers.sort(key=lambda x: x["goals"], reverse=True)   # ...a potem wg goli malejąco (stabilne)
    return scorers

def build_knockout_bracket(db: Session):
    bracket = {
        "round_of_32": [], "round_of_16": [], "quarterfinals": [], "semifinals": [], "final": [], "third_place": []
    }
    knockout_matches = db.query(models.Match).filter(
        models.Match.stage.in_(["round_32", "round_16", "quarter", "semi", "final", "third_place"])
    ).order_by(models.Match.id).all()

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

    response.set_cookie(key="player_id", value=str(new_player.id), max_age=2592000, httponly=True, samesite="lax", secure=True, path="/")
    return {"status": "ok"}

@app.post("/auth/login/")
def login_user(auth: PlayerAuth, response: Response, db: Session = Depends(get_db)):
    player = db.query(models.Player).filter(models.Player.username == auth.username).first()
    if not player or not verify_password(auth.password, player.password):
        raise HTTPException(status_code=400, detail="Błędny login lub hasło!")

    response.set_cookie(key="player_id", value=str(player.id), max_age=2592000, httponly=True, samesite="lax", secure=True, path="/")
    return {"status": "ok"}

@app.post("/auth/logout/")
def logout_user(response: Response):
    response.delete_cookie("player_id", path="/")
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

@app.get("/sw.js")
def service_worker():
    """Service Worker — serwowany z roota, by objąć całą aplikację (scope '/')."""
    sw_code = """
const CACHE = 'bwc-cache-v1';
const OFFLINE_URL = '/static/offline.html';
const PRECACHE = ['/static/offline.html', '/static/icon-192.png'];

self.addEventListener('install', (event) => {
  event.waitUntil(
    caches.open(CACHE).then((c) => c.addAll(PRECACHE)).then(() => self.skipWaiting())
  );
});

self.addEventListener('activate', (event) => {
  event.waitUntil(
    caches.keys().then((keys) => Promise.all(
      keys.filter((k) => k !== CACHE).map((k) => caches.delete(k))
    )).then(() => self.clients.claim())
  );
});

self.addEventListener('fetch', (event) => {
  const req = event.request;
  if (req.method !== 'GET') return;

  // Nawigacja (HTML): najpierw sieć, w razie braku — strona offline
  if (req.mode === 'navigate') {
    event.respondWith(
      fetch(req).catch(() => caches.match(OFFLINE_URL))
    );
    return;
  }

  // Ikony/statyczne: cache, a w tle aktualizacja
  if (req.url.includes('/static/')) {
    event.respondWith(
      caches.match(req).then((cached) => {
        const network = fetch(req).then((res) => {
          const copy = res.clone();
          caches.open(CACHE).then((c) => c.put(req, copy));
          return res;
        }).catch(() => cached);
        return cached || network;
      })
    );
  }
});
"""
    return Response(content=sw_code, media_type="application/javascript")


@app.get("/", response_class=HTMLResponse)
def read_dashboard(request: Request, db: Session = Depends(get_db)):
    players = db.query(models.Player).all()
    matches = db.query(models.Match).order_by(models.Match.match_date).all()
    # Gole podzielone na strony (gospodarz/gość) do "Mecze → Zakończone"
    for _m in matches:
        _m.goal_sides = build_goal_sides(_m) if _m.is_finished else {"rows": [], "has_sides": False}
    picks = db.query(models.UserPick).all()

    leaderboard = db.query(models.Player).order_by(models.Player.total_points.desc()).limit(10).all()
    all_players = db.query(models.Player).order_by(models.Player.total_points.desc()).all()

    # Liczba rozliczonych typów na gracza (do obliczenia skuteczności w rankingu)
    from sqlalchemy import func as _func
    settled_counts = dict(
        db.query(models.UserPick.player_id, _func.count(models.UserPick.id))
        .join(models.Match)
        .filter(models.Match.is_finished == True)
        .group_by(models.UserPick.player_id).all()
    )
    settled_picks = {pid: cnt for pid, cnt in settled_counts.items()}

    # Odznaki rankingowe — wyróżnienia w kategoriach (liderów danej kategorii)
    player_badges = {}
    def _award(pid, emoji, label):
        if pid is not None:
            player_badges.setdefault(pid, []).append({"e": emoji, "l": label})

    def _award_max_dict(vals, emoji, label, min_val=1):
        if vals:
            mx = max(vals.values())
            if mx >= min_val:
                for pid, v in vals.items():
                    if v == mx:
                        _award(pid, emoji, label)

    def _award_max_attr(attr, emoji, label, min_val=1):
        vals = {p.id: getattr(p, attr) or 0 for p in all_players}
        _award_max_dict(vals, emoji, label, min_val)

    _award_max_attr("total_points", "👑", "Lider — najwięcej punktów", 1)
    _award_max_attr("correct_predictions", "🎯", "Snajper — najwięcej trafionych typów", 1)
    _award_max_attr("current_streak", "🔥", "Seryjny — najdłuższa aktualna seria", 3)

    player_id = request.cookies.get("player_id")
    current_player = None
    current_rank = "-"  # <--- Dodane miejsce na pozycję w rankingu
    
    if player_id:
        try:
            current_player = db.query(models.Player).filter(models.Player.id == int(player_id)).first()
            # <--- Pętla sprawdzająca pozycję gracza
            if current_player:
                for idx, p in enumerate(all_players):
                    if p.id == current_player.id:
                        current_rank = idx + 1
                        break
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

    # Podsumowanie rozliczonych meczów: kto trafił dokładny wynik + kto zdobył najwięcej pkt
    _id2nick = {p.id: p.username for p in all_players}
    match_summary = {}
    for m in matches:
        if m.is_finished and m.result:
            exact, pts_list, best_pts = [], [], None
            for p in picks:
                if p.match_id != m.id:
                    continue
                nick = _id2nick.get(p.player_id)
                if not nick:
                    continue
                if p.predicted_result == m.result:
                    exact.append(nick)
                pts = p.points_earned if p.points_earned is not None else 0
                pts_list.append((nick, pts))
                if best_pts is None or pts > best_pts:
                    best_pts = pts
            # wszyscy, którzy zdobyli najwięcej punktów (może być kilku ex aequo)
            mvp_nicks = [n for n, pt in pts_list if pt == best_pts] if best_pts is not None else []
            match_summary[m.id] = {"exact": exact, "mvp_nicks": mvp_nicks, "mvp_pts": best_pts}

    # ===== Statystyki gwiazd (tylko te wybrane przez graczy) =====
    star_stats = {}
    for p in all_players:
        sp = (p.star_player or "").strip()
        if not sp:
            continue
        if sp not in star_stats:
            star_stats[sp] = {"name": sp, "goals": 0, "chosen_by": 0, "points": 0}
        star_stats[sp]["chosen_by"] += 1
        star_stats[sp]["points"] += (p.star_player_points or 0)
    for m in matches:
        if m.is_finished and m.scorers:
            for s in m.scorers:
                key = (s or "").strip()
                if key in star_stats:
                    star_stats[key]["goals"] += 1
    # punkty na gracza (średnia) + ranking: gole → punkty → popularność
    for st in star_stats.values():
        st["per_player"] = round(st["points"] / st["chosen_by"], 1) if st["chosen_by"] else 0
    star_ranking = sorted(star_stats.values(), key=lambda x: (-x["goals"], -x["points"], -x["chosen_by"]))

    group_standings = calculate_group_standings(db)
    third_place_ranking = calculate_third_place_ranking(db)
    top_scorers = calculate_top_scorers(db)
    knockout_bracket = build_knockout_bracket(db)
    upcoming_match_ids = get_upcoming_matches(db, 8)

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
        settled = db.query(models.UserPick).filter(
            models.UserPick.player_id == current_player.id
        ).join(models.Match).filter(models.Match.is_finished == True).order_by(models.Match.match_date.desc()).limit(5).all()
        recent_picks = settled

    return templates.TemplateResponse(
        request=request, name="index.html",
        context={
            "players": players, "matches": matches, "leaderboard": leaderboard,
            "all_players": all_players, "picks": picks, "settled_picks": settled_picks, "player_badges": player_badges,
            "current_player": current_player, 
            "current_rank": current_rank,  # <--- Wysłanie do HTML'a
            "active_picks": active_picks,
            "recent_picks": recent_picks,
            "group_standings": group_standings, "third_place_ranking": third_place_ranking, "top_scorers": top_scorers, "knockout_bracket": knockout_bracket,
            "pick_stats": pick_stats, "match_summary": match_summary, "star_ranking": star_ranking, "now": now_utc, "timedelta": timedelta, "upcoming_match_ids": upcoming_match_ids,
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
    player = db.query(models.Player).filter(models.Player.id == player_id).first()
    star = player.star_player if player else None
    picks = db.query(models.UserPick).filter(models.UserPick.player_id == player_id).join(models.Match).order_by(models.Match.match_date.desc()).all()
    res = []
    for pick in picks:
        m = pick.match
        res.append({
            "match_id": m.id,
            "match_date": m.match_date.isoformat(),
            "home_team": m.home_team,
            "away_team": m.away_team,
            "predicted_result": pick.predicted_result,
            "hidden": False,
            "actual_result": m.result,
            "penalties": m.penalties if m.is_finished else None,
            "scorers": m.scorers or [],
            "star_player": star,
            "points_earned": pick.points_earned,
            "breakdown": pick.points_breakdown or None,
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

    # Drużyna i gwiazda przychodzą razem (jeden zapis), ale obsługujemy też pojedyncze.
    # Każde pole ustawiamy tylko jeśli jeszcze puste – ponowne wysłanie nie powoduje błędu,
    # więc połączony zapis zawsze się powiedzie. Blokada dopiero, gdy oba ustawione.

    if favorite.favorite_team and not player.favorite_team:
        player.favorite_team = favorite.favorite_team

    if favorite.star_player and not player.star_player:
        player.star_player = favorite.star_player

    if player.favorite_team and player.star_player:
        player.favorite_locked = True

    db.commit()
    db.refresh(player)

    return {"status": "ok", "favorite_team": player.favorite_team, "star_player": player.star_player}

@app.post("/picks/")
def create_pick(
    pick: UserPickCreate,
    db: Session = Depends(get_db),
    session_player_id: Optional[str] = Cookie(None, alias="player_id"),
):
    # WERYFIKACJA TOŻSAMOŚCI: typ zapisujemy tylko dla konta z ciasteczka tej przeglądarki.
    # Chroni przed obstawianiem za kogoś innego oraz przed działaniem na zdezaktualizowanej (zacache'owanej) stronie.
    if not session_player_id or not session_player_id.isdigit() or int(session_player_id) != pick.player_id:
        raise HTTPException(status_code=403, detail="Sesja wygasła lub konto się nie zgadza. Odśwież stronę (wyczyść cache) i zaloguj się ponownie.")

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

    # ----- LOGIKA: tylko 8 najbliższych nadchodzących meczów -----
    upcoming_ids = get_upcoming_matches(db, limit=8)
    if pick.match_id not in upcoming_ids:
        raise HTTPException(status_code=400, detail="Można typować tylko 8 najbliższych meczy (kolejność dat)")

    # Jeśli typ na ten mecz już istnieje → to EDYCJA, aktualizujemy bez limitu
    existing = db.query(models.UserPick).filter(
        models.UserPick.player_id == pick.player_id,
        models.UserPick.match_id == pick.match_id
    ).first()

    if existing:
        existing.predicted_result = pick.predicted_result
        db.commit()
        return existing

    # NOWY typ — sprawdź limit 8 meczów z bieżącej puli
    user_picks_count = db.query(models.UserPick).filter(
        models.UserPick.player_id == pick.player_id,
        models.UserPick.match_id.in_(upcoming_ids)
    ).count()
    if user_picks_count >= 8:
        raise HTTPException(status_code=400, detail="Możesz obstawić maksymalnie 8 meczy (wszystkie już wybrane)")

    new_pick = models.UserPick(player_id=pick.player_id, match_id=pick.match_id, predicted_result=pick.predicted_result)
    db.add(new_pick)
    try:
        db.commit()
    except IntegrityError:
        # Wyścig: równoległy request (np. podwójne kliknięcie) zdążył już utworzyć typ.
        # Zamiast tworzyć duplikat — zaktualizuj istniejący.
        db.rollback()
        existing = db.query(models.UserPick).filter(
            models.UserPick.player_id == pick.player_id,
            models.UserPick.match_id == pick.match_id
        ).first()
        if existing:
            existing.predicted_result = pick.predicted_result
            db.commit()
            return existing
        raise
    db.refresh(new_pick)
    return new_pick

KO_DATES = {
    "round_32": datetime(2026, 6, 29, 18, 0),
    "round_16": datetime(2026, 7, 4, 18, 0),
    "quarter": datetime(2026, 7, 9, 18, 0),
    "semi": datetime(2026, 7, 14, 18, 0),
    "third_place": datetime(2026, 7, 18, 23, 0),
    "final": datetime(2026, 7, 19, 21, 0),
}

# Konkretne daty meczów dalszych rund — kolejność = kolejność PAR w drabince (NIE chronologiczna).
KO_ROUND_DATES = {
    "round_16": [
        datetime(2026, 7, 4, 23, 0),   # 1  Niemcy/Paragwaj – Francja/Szwecja
        datetime(2026, 7, 4, 19, 0),   # 2  RPA/Kanada – Holandia/Maroko
        datetime(2026, 7, 6, 21, 0),   # 3  Portugalia/Chorwacja – Hiszpania/Austria
        datetime(2026, 7, 7, 2, 0),    # 4  USA/Bośnia – Belgia/Senegal
        datetime(2026, 7, 5, 22, 0),   # 5  Brazylia/Japonia – WKS/Norwegia
        datetime(2026, 7, 6, 2, 0),    # 6  Meksyk/Ekwador – Anglia/DR Konga
        datetime(2026, 7, 7, 18, 0),   # 7  Argentyna/RZP – Australia/Egipt
        datetime(2026, 7, 7, 22, 0),   # 8  Szwajcaria/Algieria – Kolumbia/Ghana
    ],
    "quarter": [
        datetime(2026, 7, 9, 22, 0),   # 1
        datetime(2026, 7, 10, 21, 0),  # 2
        datetime(2026, 7, 11, 23, 0),  # 3
        datetime(2026, 7, 12, 3, 0),   # 4
    ],
    "semi": [
        datetime(2026, 7, 14, 21, 0),  # 1
        datetime(2026, 7, 15, 21, 0),  # 2
    ],
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
    def all_done(stage):
        ms = db.query(models.Match).filter(models.Match.stage == stage).all()
        return bool(ms) and all(m.is_finished for m in ms)
    def has(stage):
        return db.query(models.Match).filter(models.Match.stage == stage).first() is not None
    def winners_of(stage):
        ms = db.query(models.Match).filter(models.Match.stage == stage, models.Match.is_finished == True).order_by(models.Match.match_date, models.Match.id).all()
        return [_ko_winner(m) for m in ms]

    # 1) Faza grupowa zakończona → utwórz 1/16 finału (Format MŚ 2026)
    if all_done("group") and not has("round_32"):
        q = _qualified_32(db)
        if len(q) >= 32:
            winners = {g: n for n, g, p in q if p == 1}
            runners = {g: n for n, g, p in q if p == 2}
            third_list = [(n, g) for n, g, p in q if p == 3]

            # ===== Oficjalna tabela FIFA: które 3. miejsce może trafić na danego zwycięzcę =====
            # (zwycięzca grupy nie może trafić na 3. miejsce z własnej grupy)
            THIRD_ALLOWED = {
                "A": {"C", "E", "F", "H", "I"},
                "B": {"E", "F", "G", "I", "J"},
                "E": {"A", "B", "C", "D", "F"},
                "G": {"A", "E", "H", "I", "J"},
                "I": {"C", "D", "F", "G", "H"},
                "K": {"D", "E", "I", "J", "L"},
                "L": {"E", "H", "I", "J", "K"},
                # D nie ma w mediach pełnego 5-zestawu (zwykle rozstrzygnięte) — bierze resztę:
                "D": {"A", "B", "C", "E", "F", "G", "H", "I", "J", "K", "L"},
            }
            winner_groups = ["A", "B", "D", "E", "G", "I", "K", "L"]
            third_groups = [g for _, g in third_list]            # grupy 8 zakwalifikowanych 3. miejsc
            third_name_by_group = {g: n for n, g in third_list}

            # Wymuszone, potwierdzone przypisania wg oficjalnej tabeli FIFA / FlashScore
            # (stosowane tylko jeśli dana grupa 3. miejsca faktycznie się zakwalifikowała):
            #   E1→D(Paragwaj) · I1→F(Szwecja) · D1→B(Bośnia) · A1→E(Ekwador)
            #   G1→I(Senegal) · B1→J(Algieria) · L1→K(DR Konga) · K1→L(Ghana)
            FORCED_THIRD = {"E": "D", "I": "F", "D": "B", "A": "E", "G": "I", "B": "J", "L": "K", "K": "L"}
            assigned_group = {}   # third_group -> winner_group
            for _wg, _tg in FORCED_THIRD.items():
                if _tg in third_groups:
                    assigned_group[_tg] = _wg
            forced_winners = {wg for wg, tg in FORCED_THIRD.items() if tg in third_groups}
            remaining_winners = [w for w in winner_groups if w not in forced_winners]
            remaining_thirds = [g for g in third_groups if g not in assigned_group]

            # Pozostałe przypisania: dopasowanie dwudzielne (augmenting path) w ramach dozwolonych grup FIFA.
            def _try_assign(wg, visited):
                for tg in remaining_thirds:
                    if tg in THIRD_ALLOWED.get(wg, set()) and tg not in visited:
                        visited.add(tg)
                        cur = assigned_group.get(tg)
                        if cur is None or (cur in remaining_winners and _try_assign(cur, visited)):
                            assigned_group[tg] = wg
                            return True
                return False
            for wg in sorted(remaining_winners, key=lambda w: len([g for g in remaining_thirds if g in THIRD_ALLOWED.get(w, set())])):
                _try_assign(wg, set())

            assigned_thirds = {}   # winner_group -> nazwa drużyny 3. miejsca
            used_thirds = set()
            wg_to_tg = {wg: tg for tg, wg in assigned_group.items()}
            for wg in winner_groups:
                tg = wg_to_tg.get(wg)
                if tg is None:
                    # Fallback (gdyby dopasowanie nie pokryło wszystkich) — pierwsze wolne z innej grupy
                    for tn, tgg in third_list:
                        if tn not in used_thirds and tgg != wg:
                            assigned_thirds[wg] = tn; used_thirds.add(tn); break
                else:
                    nm = third_name_by_group.get(tg)
                    assigned_thirds[wg] = nm
                    if nm:
                        used_thirds.add(nm)

            # Pomocnicze funkcje pobierające drużyny do drabinki
            def W(g): return winners.get(g, f"Brak 1{g}")
            def R(g): return runners.get(g, f"Brak 2{g}")
            def T(g): return assigned_thirds.get(g, f"Brak 3{g}")

            # Oficjalny układ par 1/16 (kolejność od góry wg FlashScore/FIFA — winner = gospodarz)
            bracket_order = [
                (W('E'), T('E')),   # 1.  E1 vs 3.(D)
                (W('I'), T('I')),   # 2.  I1 vs 3.(F)
                (R('A'), R('B')),   # 3.  A2 vs B2
                (W('F'), R('C')),   # 4.  F1 vs C2
                (R('K'), R('L')),   # 5.  K2 vs L2
                (W('H'), R('J')),   # 6.  H1 vs J2  (Hiszpania)
                (W('D'), T('D')),   # 7.  D1 vs 3.(B)
                (W('G'), T('G')),   # 8.  G1 vs 3.   (Belgia)
                (W('C'), R('F')),   # 9.  C1 vs F2
                (R('E'), R('I')),   # 10. E2 vs I2
                (W('A'), T('A')),   # 11. A1 vs 3.   (Meksyk)
                (W('L'), T('L')),   # 12. L1 vs 3.
                (W('J'), R('H')),   # 13. J1 vs H2
                (R('D'), R('G')),   # 14. D2 vs G2
                (W('B'), T('B')),   # 15. B1 vs 3.   (Szwajcaria)
                (W('K'), T('K')),   # 16. K1 vs 3.
            ]

            # Konkretne daty meczów 1/16 — kolejność dokładnie jak bracket_order powyżej
            R32_DATES = [
                datetime(2026, 6, 29, 22, 30),  # 1.  Niemcy vs Paragwaj
                datetime(2026, 6, 30, 23, 0),   # 2.  Francja vs Szwecja
                datetime(2026, 6, 28, 21, 0),   # 3.  RPA vs Kanada
                datetime(2026, 6, 30, 3, 0),    # 4.  Holandia vs Maroko
                datetime(2026, 7, 3, 1, 0),     # 5.  Portugalia vs Chorwacja
                datetime(2026, 7, 2, 21, 0),    # 6.  Hiszpania vs Austria
                datetime(2026, 7, 2, 2, 0),     # 7.  USA vs Bośnia
                datetime(2026, 7, 1, 22, 0),    # 8.  Belgia vs Senegal
                datetime(2026, 6, 29, 19, 0),   # 9.  Brazylia vs Japonia
                datetime(2026, 6, 30, 19, 0),   # 10. WKS vs Norwegia
                datetime(2026, 7, 1, 3, 0),     # 11. Meksyk vs Ekwador
                datetime(2026, 7, 1, 18, 0),    # 12. Anglia vs DR Konga
                datetime(2026, 7, 4, 0, 0),     # 13. Argentyna vs RZP
                datetime(2026, 7, 3, 20, 0),    # 14. Australia vs Egipt
                datetime(2026, 7, 3, 5, 0),     # 15. Szwajcaria vs Algieria
                datetime(2026, 7, 4, 3, 30),    # 16. Kolumbia vs Ghana
            ]
            for i, (home, away) in enumerate(bracket_order):
                when = R32_DATES[i] if i < len(R32_DATES) else KO_DATES["round_32"] + timedelta(days=i//4, hours=(i%4)*3)
                _ko_create(db, home, away, "round_32", when)

    # 2) Kolejne rundy — buduj/aktualizuj na bieżąco
    TBD = "—"
    def slot_winner(m):
        return _ko_winner(m) or TBD

    for stage, nxt in [("round_32", "round_16"), ("round_16", "quarter"), ("quarter", "semi")]:
        if not has(stage):
            continue
        # WAŻNE: kolejność wg id (kolejność tworzenia = kolejność par w drabince),
        # NIE wg match_date — bo daty nie są chronologiczne i zepsułyby parowanie.
        prev = db.query(models.Match).filter(models.Match.stage == stage).order_by(models.Match.id).all()
        n_pairs = len(prev) // 2
        if n_pairs == 0:
            continue
        existing = db.query(models.Match).filter(models.Match.stage == nxt).order_by(models.Match.id).all()
        date_list = KO_ROUND_DATES.get(nxt, [])
        for i in range(n_pairs):
            home = slot_winner(prev[2*i])
            away = slot_winner(prev[2*i+1])
            when = date_list[i] if i < len(date_list) else KO_DATES[nxt] + timedelta(days=i//2)
            if i < len(existing):
                nm = existing[i]
                if not nm.is_finished:
                    nm.home_team = home
                    nm.away_team = away
                    nm.match_date = when
            else:
                db.add(models.Match(home_team=home, away_team=away, match_date=when,
                                    stage=nxt, multiplier=STAGE_MULTIPLIERS.get(nxt, 1), is_locked=False, is_finished=False, result=None))
        db.commit()

    # 3) Półfinały → finał + mecz o 3. miejsce
    if has("semi"):
        sm = db.query(models.Match).filter(models.Match.stage == "semi").order_by(models.Match.id).all()
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

@app.post("/admin/rebuild-bracket", dependencies=[Depends(verify_admin)])
def admin_rebuild_bracket(db: Session = Depends(get_db)):
    """Kasuje całą drabinkę pucharową i buduje ją od nowa z aktualnym przypisaniem 3. miejsc i datami.
    Lekkie — NIE przelicza punktów graczy (brak ryzyka OOM). Nie rusza fazy grupowej."""
    ko_stages = ["round_32", "round_16", "quarter", "semi", "final", "third_place"]
    ko_matches = db.query(models.Match).filter(models.Match.stage.in_(ko_stages)).all()
    ko_ids = [m.id for m in ko_matches]
    removed_picks = 0
    if ko_ids:
        removed_picks = db.query(models.UserPick).filter(
            models.UserPick.match_id.in_(ko_ids)
        ).delete(synchronize_session=False)
        db.query(models.Match).filter(
            models.Match.id.in_(ko_ids)
        ).delete(synchronize_session=False)
        db.commit()
    advance_tournament_if_ready(db)
    built = db.query(models.Match).filter(models.Match.stage == "round_32").count()
    return {
        "status": "ok",
        "usuniete_mecze_pucharowe": len(ko_ids),
        "usuniete_typy_pucharowe": removed_picks,
        "round_32_po_przebudowie": built,
    }

@app.put("/matches/{match_id}/result", dependencies=[Depends(verify_admin)])
def update_match_result(match_id: int, result: MatchResultUpdate, db: Session = Depends(get_db)):
    match = db.query(models.Match).filter(models.Match.id == match_id).first()
    if not match: raise HTTPException(status_code=404)

    was_finished = match.is_finished  # czy to korekta już rozliczonego meczu

    match.result = result.result
    match.scorers = result.scorers
    match.scorer_teams = result.scorer_teams
    match.scorer_minutes = result.scorer_minutes
    match.penalties = result.penalties
    match.is_finished = True
    match.is_locked = True
    db.commit()

    picks = db.query(models.UserPick).filter(models.UserPick.match_id == match_id).all()
    picks_by_player = {p.player_id: p for p in picks}
    
    # Pobieramy wszystkich graczy, aby wyłapać tych, którzy zaspali i nie oddali typu
    all_players = db.query(models.Player).all()

    for player in all_players:
        pick = picks_by_player.get(player.id)

        if pick:
            # GRACZ OBSTAWIŁ TEN MECZ - normalne rozliczenie
            pd = calculate_points_with_bonus(
                pick.predicted_result, result.result, match.stage,
                match.home_team, match.away_team, player.favorite_team,
                player.star_player, result.scorers
            )
            match_total = pd["total_points"]

            if was_finished:
                # KOREKTA
                bd = dict(pick.points_breakdown or {})
                old_sb = bd.get("streak_bonus", 0)
                old_fav = bd.get("favorite", 0)
                old_star = bd.get("star", 0)
                new_sb = old_sb if pd["base_points"] > 0 else 0
                grand_total = match_total + new_sb

                player.total_points += (grand_total - (pick.points_earned or 0))
                # FIX: agregaty reprezentacji i gwiazdy też muszą iść o RÓŻNICĘ
                # (np. gdy strzelcy zostali dopisani już po zapisaniu samego wyniku).
                player.favorite_team_points += (pd["favorite_bonus"] - old_fav)
                player.star_player_points += (pd["star_player_bonus"] - old_star)
                pick.points_earned = grand_total
                
                bd.update({
                    "base": pd["base_points"], "high_score": pd["high_score_bonus"], "underdog": pd["underdog_bonus"],
                    "favorite": pd["favorite_bonus"], "star": pd["star_player_bonus"],
                    "multiplier": pd["multiplier"], "match_total": match_total, 
                    "streak_bonus": new_sb, "grand_total": grand_total
                })
                pick.points_breakdown = bd
            else:
                # PIERWSZE rozliczenie
                sb = 0
                if pd["base_points"] > 0:
                    player.correct_predictions += 1
                    player.current_streak += 1
                    if player.current_streak > player.longest_streak:
                        player.longest_streak = player.current_streak
                    sb = streak_bonus(player.current_streak)
                else:
                    player.current_streak = 0

                grand_total = match_total + sb
                pick.points_earned = grand_total
                
                player.total_points += grand_total
                player.favorite_team_points += pd["favorite_bonus"]
                player.star_player_points += pd["star_player_bonus"]
                
                pick.points_breakdown = {
                    "base": pd["base_points"], "high_score": pd["high_score_bonus"], "underdog": pd["underdog_bonus"],
                    "favorite": pd["favorite_bonus"], "star": pd["star_player_bonus"], "multiplier": pd["multiplier"],
                    "streak_bonus": sb, "streak_len": player.current_streak,
                    "match_total": match_total, "grand_total": grand_total
                }
        else:
            # GRACZ NIE OBSTAWIŁ TEGO MECZU
            if not was_finished:
                # Surowe zasady: nie zagrałeś = resetujemy Twoją serię do zera
                player.current_streak = 0

    db.commit()

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
    # Mecz "trwa": zaczął się, nie jest jeszcze rozliczony i nie minęło więcej niż ~2,5h od startu
    live_exists = db.query(models.Match).filter(
        models.Match.is_finished == False,
        models.Match.match_date <= now,
        models.Match.match_date > now - timedelta(hours=2, minutes=30)
    ).first() is not None

    next_match = db.query(models.Match).filter(
        models.Match.is_finished == False,
        models.Match.match_date > now
    ).order_by(models.Match.match_date).first()

    if not next_match:
        return {"has_next": False, "is_live": live_exists}

    time_left = next_match.match_date - now
    return {
        "has_next": True,
        "is_live": live_exists,
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

@app.post("/admin/verify", dependencies=[Depends(verify_admin)])
def verify_admin_secret():
    """Sprawdza, czy podany klucz jest poprawny — używane przez bramkę panelu admina."""
    return {"ok": True}

@app.delete("/admin/players/{player_id}", dependencies=[Depends(verify_admin)])
def delete_player(player_id: int, db: Session = Depends(get_db)):
    """Usuwa gracza wraz z jego typami. Wymaga klucza ADMIN_SECRET."""
    player = db.query(models.Player).filter(models.Player.id == player_id).first()
    if not player:
        raise HTTPException(status_code=404, detail="Nie znaleziono gracza")
    username = player.username
    db.query(models.UserPick).filter(models.UserPick.player_id == player_id).delete()
    db.delete(player)
    db.commit()
    return {"status": "ok", "deleted": player_id, "username": username}

class PasswordReset(BaseModel):
    new_password: str

@app.put("/admin/players/{player_id}/reset-password", dependencies=[Depends(verify_admin)])
def admin_reset_password(player_id: int, data: PasswordReset, db: Session = Depends(get_db)):
    """Ustawia nowe hasło graczowi (gdy zapomniał). Wymaga klucza ADMIN_SECRET."""
    player = db.query(models.Player).filter(models.Player.id == player_id).first()
    if not player:
        raise HTTPException(status_code=404, detail="Nie znaleziono gracza")
    if not data.new_password or len(data.new_password) < 4:
        raise HTTPException(status_code=400, detail="Hasło musi mieć min. 4 znaki")
    player.password = hash_password(data.new_password)
    db.commit()
    return {"status": "ok", "player_id": player_id, "username": player.username}

@app.get("/admin", response_class=HTMLResponse)
def admin_panel(request: Request, db: Session = Depends(get_db)):
    players = db.query(models.Player).order_by(models.Player.total_points.desc()).all()
    matches = db.query(models.Match).order_by(models.Match.match_date.asc()).all()
    
    # Budowanie wierszy tabeli graczy
    players_html = ""
    for p in players:
        status = '<span class="text-green-400 bg-green-500/10 px-2 py-0.5 rounded text-xs font-medium">W grze</span>' if p.is_alive else '<span class="text-red-400 bg-red-500/10 px-2 py-0.5 rounded text-xs font-medium">Odpadł</span>'
        safe_username = (p.username or "").replace("\\", "\\\\").replace("'", "\\'")
        players_html += f"""
        <tr class="border-b border-white/5 hover:bg-white/[0.02] text-sm transition">
            <td class="p-3 font-semibold text-white">{p.username}</td>
            <td class="p-3 text-amber-400 font-bold">{p.total_points} pkt</td>
            <td class="p-3 font-medium text-xs text-gray-300 truncate max-w-[140px]">{p.full_name or '-'}</td>
            <td class="p-3 font-medium text-xs text-gray-400 truncate max-w-[120px]">{p.star_player or '-'}</td>
            <td class="p-3 font-medium text-xs text-gray-400 truncate max-w-[120px]">{p.favorite_team or '-'}</td>
            <td class="p-3 text-center">{status}</td>
            <td class="p-3 text-right whitespace-nowrap">
                <button onclick="resetPass({p.id}, '{safe_username}')" class="bg-amber-600/20 text-amber-400 border border-amber-600/30 hover:bg-amber-600 hover:text-white text-xs font-bold px-3 py-1.5 rounded-lg transition mr-1">🔑 Hasło</button>
                <button onclick="deleteUser({p.id}, '{safe_username}')" class="bg-rose-600/20 text-rose-400 border border-rose-600/30 hover:bg-rose-600 hover:text-white text-xs font-bold px-3 py-1.5 rounded-lg transition">🗑 Usuń</button>
            </td>
        </tr>
        """

    # Budowanie kafelków z meczami
    pending_html = ""
    finished_html = ""
    pending_count = 0
    finished_count = 0

    for m in matches:
        scorers_val = ", ".join(m.scorers) if m.scorers else ""

        # Podział istniejących strzelców na gospodarza/gościa (do dwóch pól w panelu), z minutą.
        _home_sc, _away_sc = [], []
        _sc = m.scorers or []
        _st = m.scorer_teams or []
        _mn = m.scorer_minutes or []
        def _label(_i, _n):
            _min = _mn[_i] if _i < len(_mn) else None
            return f"{_n} {_min}" if _min else _n
        if _st and len(_st) == len(_sc):
            for _i, (_n, _t) in enumerate(zip(_sc, _st)):
                (_away_sc if _t == m.away_team else _home_sc).append(_label(_i, _n))
        else:
            _home_sc = [_label(_i, _n) for _i, _n in enumerate(_sc)]  # stare dane — admin rozdzieli
        home_scorers_val = ", ".join(_home_sc)
        away_scorers_val = ", ".join(_away_sc)
        is_ko = m.stage != "group"
        pen_input = f'<input type="text" id="pen-{m.id}" value="{m.penalties or ""}" placeholder="Karne (np. 4:3)" class="w-full bg-[#1a1e26] border border-white/10 rounded-lg px-3 py-2 text-xs text-amber-300 focus:outline-none focus:border-amber-500 mb-2">' if is_ko else ""
        
        date_str = m.match_date.strftime("%d.%m %H:%M") if m.match_date else ""
        card_class = "match-card p-4 rounded-xl border bg-[#14171d] flex flex-col gap-3 shadow-sm transition hover:border-white/20"
        search_data = f"{m.home_team.lower()} {m.away_team.lower()}"

        if m.is_finished:
            finished_count += 1
            pen_label = f' <span class="text-amber-500 text-xs">(k. {m.penalties})</span>' if m.penalties else ''
            finished_html += f"""
            <div class="{card_class} border-white/5" data-teams="{search_data}">
                <div class="flex items-center justify-between border-b border-white/5 pb-2">
                    <span class="text-[10px] font-mono text-gray-500">{date_str} | ID: {m.id}</span>
                    <span class="text-gray-400 bg-white/5 px-2 py-0.5 rounded text-[10px] font-medium">Zakończony</span>
                </div>
                <div class="text-sm font-bold text-white text-center">
                    {m.home_team} <span class="text-emerald-400 mx-1">{m.result}</span> {m.away_team}{pen_label}
                </div>
                <div class="mt-auto pt-2 border-t border-white/5">
                    <p class="text-[10px] text-gray-500 mb-1.5 italic">Popraw wynik / bramki:</p>
                    <div class="flex gap-2 mb-2">
                        <input type="text" id="res-{m.id}" value="{m.result or ''}" class="w-16 text-center bg-[#1a1e26] border border-white/10 rounded-lg px-2 py-2 text-xs text-white focus:outline-none focus:border-amber-500">
                        <div class="flex-1 flex flex-col gap-1.5">
                            <input type="text" id="sch-{m.id}" data-team="{m.home_team}" value="{home_scorers_val}" placeholder="⚽ {m.home_team} — np. Müller 23" class="w-full bg-[#1a1e26] border border-emerald-500/30 rounded-lg px-3 py-2 text-xs text-white focus:outline-none focus:border-emerald-500">
                            <input type="text" id="sca-{m.id}" data-team="{m.away_team}" value="{away_scorers_val}" placeholder="⚽ {m.away_team} — np. Džeko 78" class="w-full bg-[#1a1e26] border border-sky-500/30 rounded-lg px-3 py-2 text-xs text-white focus:outline-none focus:border-sky-500">
                        </div>
                    </div>
                    {pen_input}
                    <button onclick="saveMatch({m.id})" class="w-full bg-white/10 hover:bg-white/20 text-white font-bold text-xs py-2 rounded-lg transition">Aktualizuj wynik</button>
                </div>
            </div>
            """
        else:
            pending_count += 1
            pending_html += f"""
            <div class="{card_class} border-l-2 border-l-amber-500 border-white/5" data-teams="{search_data}">
                <div class="flex items-center justify-between border-b border-white/5 pb-2">
                    <span class="text-[10px] font-mono text-gray-500">{date_str} | ID: {m.id}</span>
                    <span class="text-amber-400 bg-amber-500/10 px-2 py-0.5 rounded text-[10px] font-medium animate-pulse">Oczekuje</span>
                </div>
                <div class="text-sm font-bold text-white text-center py-1">
                    {m.home_team} <span class="text-gray-600 mx-1">vs</span> {m.away_team}
                </div>
                <div class="mt-auto pt-2">
                    <div class="flex gap-2 mb-2">
                        <input type="text" id="res-{m.id}" placeholder="Wynik" class="w-16 text-center bg-[#1a1e26] border border-amber-500/40 rounded-lg px-2 py-2 text-xs text-white focus:outline-none focus:border-amber-500">
                        <div class="flex-1 flex flex-col gap-1.5">
                            <input type="text" id="sch-{m.id}" data-team="{m.home_team}" placeholder="⚽ {m.home_team} — np. Müller 23" class="w-full bg-[#1a1e26] border border-emerald-500/30 rounded-lg px-3 py-2 text-xs text-white focus:outline-none focus:border-emerald-500">
                            <input type="text" id="sca-{m.id}" data-team="{m.away_team}" placeholder="⚽ {m.away_team} — np. Džeko 78" class="w-full bg-[#1a1e26] border border-sky-500/30 rounded-lg px-3 py-2 text-xs text-white focus:outline-none focus:border-sky-500">
                        </div>
                    </div>
                    {pen_input}
                    <button onclick="saveMatch({m.id})" class="w-full bg-amber-500 hover:bg-amber-600 text-gray-900 font-bold text-xs py-2.5 rounded-lg transition shadow-md">Rozlicz Punkty</button>
                </div>
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
            ::-webkit-scrollbar {{ width: 6px; height: 6px; }}
            ::-webkit-scrollbar-thumb {{ background: rgba(255,255,255,0.08); border-radius: 10px; }}
        </style>
    </head>
    <body class="p-4 md:p-8">
        <div id="admin-gate" class="min-h-screen flex items-center justify-center">
            <div class="bg-[#14171d] border border-white/10 rounded-2xl p-8 w-full max-w-sm shadow-2xl">
                <h1 class="text-xl font-bold text-white mb-1">🔐 Panel Admina</h1>
                <p class="text-xs text-gray-500 mb-5">Podaj klucz dostępu, aby wejść do panelu.</p>
                <input type="password" id="gate-secret" placeholder="ADMIN_SECRET" onkeydown="if(event.key==='Enter')unlockAdmin()" class="w-full bg-[#1a1e26] border border-white/10 rounded-lg px-4 py-3 text-sm text-white focus:outline-none focus:border-amber-500 mb-3">
                <button onclick="unlockAdmin()" class="w-full bg-amber-500 hover:bg-amber-600 text-gray-900 font-bold text-sm py-3 rounded-lg transition">Odblokuj panel</button>
                <p id="gate-error" class="text-xs text-rose-400 mt-3 hidden">Nieprawidłowy klucz dostępu.</p>
            </div>
        </div>

        <div id="admin-content" style="display:none;">
        <div class="max-w-7xl mx-auto">
            
            <div class="flex flex-col md:flex-row items-start md:items-center justify-between border-b border-white/10 pb-5 mb-6 gap-4">
                <div>
                    <h1 class="text-2xl font-bold text-white tracking-tight">⚙️ Panel Admina</h1>
                    <p class="text-xs text-gray-500 mt-1">Zarządzanie wynikami Mistrzostw Świata 2026</p>
                </div>
                <div class="flex flex-wrap items-center gap-2 bg-[#14171d] p-1.5 rounded-xl border border-white/5">
                    <input type="password" id="admin-secret-input" placeholder="Klucz ADMIN_SECRET" class="bg-[#1a1e26] border border-white/5 rounded-lg px-3 py-1.5 text-xs text-white focus:outline-none focus:border-amber-500 w-40">
                    <button onclick="saveSecret()" class="bg-white/10 hover:bg-white/20 text-white text-xs font-bold px-3 py-1.5 rounded-lg transition">Zapisz</button>
                    <button onclick="buildKnockout()" class="bg-emerald-600/20 text-emerald-400 border border-emerald-600/30 hover:bg-emerald-600 hover:text-white text-xs font-bold px-3 py-1.5 rounded-lg transition">🏆 Zbuduj Drabinkę</button>
                    <button onclick="rebuildKnockout()" class="bg-amber-600/20 text-amber-400 border border-amber-600/30 hover:bg-amber-600 hover:text-white text-xs font-bold px-3 py-1.5 rounded-lg transition">♻️ Przebuduj Drabinkę</button>
                    <button onclick="recalculateAll()" class="bg-rose-600/20 text-rose-400 border border-rose-600/30 hover:bg-rose-600 hover:text-white text-xs font-bold px-3 py-1.5 rounded-lg transition">⚠️ Przelicz wszystko</button>
                </div>
            </div>

            <div class="flex gap-2 mb-6 border-b border-white/5 pb-4 overflow-x-auto">
                <button onclick="showTab('pending')" id="btn-pending" class="px-5 py-2.5 text-sm font-bold rounded-xl bg-amber-500 text-black shrink-0 transition shadow-lg shadow-amber-500/10">Do rozliczenia ({pending_count})</button>
                <button onclick="showTab('finished')" id="btn-finished" class="px-5 py-2.5 text-sm font-bold rounded-xl bg-white/5 text-gray-400 hover:text-white shrink-0 transition">Zakończone ({finished_count})</button>
                <button onclick="showTab('players')" id="btn-players" class="px-5 py-2.5 text-sm font-bold rounded-xl bg-white/5 text-gray-400 hover:text-white shrink-0 transition">Tabela Graczy</button>
            </div>

            <div id="search-container" class="mb-6 relative">
                <input type="text" id="searchInput" onkeyup="filterMatches()" placeholder="🔍 Wyszukaj drużynę (np. Polska, Brazylia)..." class="w-full bg-[#14171d] border border-white/10 rounded-xl px-5 py-3.5 text-sm text-white focus:outline-none focus:border-amber-500 shadow-sm transition">
            </div>

            <div id="tab-pending" class="grid grid-cols-1 md:grid-cols-2 xl:grid-cols-3 gap-5">
                {pending_html}
            </div>

            <div id="tab-finished" class="grid grid-cols-1 md:grid-cols-2 xl:grid-cols-3 gap-5 hidden">
                {finished_html}
            </div>

            <div id="tab-players" class="hidden">
                <div class="bg-[#14171d] border border-white/5 rounded-2xl p-1 shadow-xl overflow-x-auto">
                    <table class="w-full text-left border-collapse">
                        <thead>
                            <tr class="border-b border-white/10 text-xs uppercase tracking-wider text-gray-500">
                                <th class="p-4 font-semibold">Gracz</th>
                                <th class="p-4 font-semibold">Punkty</th>
                                <th class="p-4 font-semibold">Imię i nazwisko</th>
                                <th class="p-4 font-semibold">Gwiazda</th>
                                <th class="p-4 font-semibold">Zespół</th>
                                <th class="p-4 font-semibold text-center">Status</th>
                                <th class="p-4 font-semibold text-right">Akcje</th>
                            </tr>
                        </thead>
                        <tbody>
                            {players_html}
                        </tbody>
                    </table>
                </div>
            </div>

        </div>
        </div>

        <script>
            // Obsługa zapisywania klucza
            document.addEventListener('DOMContentLoaded', () => {{
                const savedSecret = localStorage.getItem('app_admin_secret');
                if (savedSecret) {{
                    document.getElementById('admin-secret-input').value = savedSecret;
                    // automatyczne odblokowanie, jeśli zapisany klucz jest poprawny
                    tryUnlock(savedSecret);
                }}
            }});

            async function tryUnlock(secret) {{
                try {{
                    const r = await fetch('/admin/verify', {{ method: 'POST', headers: {{ 'x-admin-secret': secret }} }});
                    if (r.ok) {{
                        document.getElementById('admin-gate').style.display = 'none';
                        document.getElementById('admin-content').style.display = 'block';
                        localStorage.setItem('app_admin_secret', secret);
                        return true;
                    }}
                }} catch (e) {{}}
                return false;
            }}

            async function unlockAdmin() {{
                const val = document.getElementById('gate-secret').value.trim();
                if (!val) return;
                const ok = await tryUnlock(val);
                if (!ok) {{
                    document.getElementById('gate-error').classList.remove('hidden');
                }}
            }}

            async function deleteUser(id, username) {{
                const secret = localStorage.getItem('app_admin_secret');
                if (!secret) return alert('Brak klucza — odśwież i zaloguj się ponownie.');
                if (!confirm('Na pewno usunąć gracza „' + username + '"? Usunie to też wszystkie jego typy. Tej operacji nie można cofnąć.')) return;
                try {{
                    const r = await fetch('/admin/players/' + id, {{ method: 'DELETE', headers: {{ 'x-admin-secret': secret }} }});
                    if (r.ok) {{
                        alert('Usunięto gracza „' + username + '".');
                        location.reload();
                    }} else {{
                        const e = await r.json();
                        alert('Błąd: ' + (e.detail || 'nie udało się usunąć'));
                    }}
                }} catch (e) {{ alert('Błąd połączenia.'); }}
            }}

            async function resetPass(id, username) {{
                const secret = localStorage.getItem('app_admin_secret');
                if (!secret) return alert('Brak klucza — odśwież i zaloguj się ponownie.');
                const newPass = prompt('Nowe hasło dla gracza „' + username + '" (min. 4 znaki):');
                if (newPass === null) return;
                if (newPass.trim().length < 4) return alert('Hasło musi mieć min. 4 znaki.');
                try {{
                    const r = await fetch('/admin/players/' + id + '/reset-password', {{
                        method: 'PUT',
                        headers: {{ 'x-admin-secret': secret, 'Content-Type': 'application/json' }},
                        body: JSON.stringify({{ new_password: newPass.trim() }})
                    }});
                    if (r.ok) {{
                        alert('Hasło gracza „' + username + '" zostało zmienione. Przekaż mu nowe hasło: ' + newPass.trim());
                    }} else {{
                        const e = await r.json();
                        alert('Błąd: ' + (e.detail || 'nie udało się zmienić hasła'));
                    }}
                }} catch (e) {{ alert('Błąd połączenia.'); }}
            }}

            function saveSecret() {{
                const val = document.getElementById('admin-secret-input').value.trim();
                if(!val) return alert('Wpisz sekretny klucz!');
                localStorage.setItem('app_admin_secret', val);
                alert('Klucz autoryzacyjny zapisany!');
            }}

            // Obsługa Zakładek (Tabów)
            function showTab(tabId) {{
                document.getElementById('tab-pending').classList.add('hidden');
                document.getElementById('tab-finished').classList.add('hidden');
                document.getElementById('tab-players').classList.add('hidden');
                
                const inactiveClass = "px-5 py-2.5 text-sm font-bold rounded-xl bg-white/5 text-gray-400 hover:text-white shrink-0 transition";
                const activeClass = "px-5 py-2.5 text-sm font-bold rounded-xl bg-amber-500 text-black shrink-0 transition shadow-lg shadow-amber-500/10";

                document.getElementById('btn-pending').className = inactiveClass;
                document.getElementById('btn-finished').className = inactiveClass;
                document.getElementById('btn-players').className = inactiveClass;

                document.getElementById('tab-' + tabId).classList.remove('hidden');
                document.getElementById('btn-' + tabId).className = activeClass;

                if (tabId === 'players') {{
                    document.getElementById('search-container').classList.add('hidden');
                }} else {{
                    document.getElementById('search-container').classList.remove('hidden');
                    filterMatches(); // Odśwież wyszukiwanie dla nowej zakładki
                }}
            }}

            // Szybkie Wyszukiwanie Meczów
            function filterMatches() {{
                const query = document.getElementById('searchInput').value.toLowerCase();
                document.querySelectorAll('.match-card').forEach(card => {{
                    if(card.dataset.teams.includes(query)) {{
                        card.style.display = 'flex';
                    }} else {{
                        card.style.display = 'none';
                    }}
                }});
            }}

            async function buildKnockout() {{
                const secret = document.getElementById('admin-secret-input').value.trim();
                if (!secret) return alert('Najpierw podaj ADMIN_SECRET!'); 
                if (!confirm('Zbudować drabinkę pucharową z dostępnych drużyn?')) return;
                try {{
                    const r = await fetch('/admin/advance', {{ method: 'POST', headers: {{ 'x-admin-secret': secret }} }});
                    if (r.ok) {{ alert('Gotowe! Drabinka zaktualizowana.'); location.reload(); }}
                    else {{ const e = await r.json(); alert('Błąd: ' + JSON.stringify(e.detail || e)); }}
                }} catch (err) {{ alert('Błąd: ' + err); }}
            }}

            async function rebuildKnockout() {{
                const secret = document.getElementById('admin-secret-input').value.trim();
                if (!secret) return alert('Najpierw podaj ADMIN_SECRET!');
                if (!confirm('Przebudować drabinkę OD NOWA? Skasuje obecną drabinkę (i ewentualne typy na mecze pucharowe) i zbuduje ją ponownie z poprawnym przypisaniem 3. miejsc i datami. Faza grupowa, punkty i typy grupowe NIE są ruszane.')) return;
                try {{
                    const r = await fetch('/admin/rebuild-bracket', {{ method: 'POST', headers: {{ 'x-admin-secret': secret }} }});
                    if (r.ok) {{ const d = await r.json(); alert('Gotowe! Drabinka przebudowana. Mecze 1/16: ' + d.round_32_po_przebudowie + ', usunięte stare: ' + d.usuniete_mecze_pucharowe); location.reload(); }}
                    else {{ const e = await r.json(); alert('Błąd: ' + JSON.stringify(e.detail || e)); }}
                }} catch (err) {{ alert('Błąd: ' + err); }}
            }}

            async function recalculateAll() {{
                if (!confirm('Czy na pewno chcesz przeliczyć całą bazę danych od nowa? Skrypt usunie złą drabinkę i zbuduje punkty od zera.')) return;
                try {{
                    const r = await fetch('/admin/recalculate-all');
                    const d = await r.json();
                    alert(d.message || 'Przeliczono!');
                    location.reload();
                }} catch(err) {{ alert('Błąd: ' + err); }}
            }}

            async function saveMatch(matchId) {{
                const secret = document.getElementById('admin-secret-input').value.trim();
                if (!secret) return alert('Błąd: Musisz podać ADMIN_SECRET na górze!');

                const resultString = document.getElementById('res-' + matchId).value.trim();
                const homeEl = document.getElementById('sch-' + matchId);
                const awayEl = document.getElementById('sca-' + matchId);
                const penEl = document.getElementById('pen-' + matchId);
                const penString = penEl ? penEl.value.trim() : '';

                if (!resultString) return alert('Błąd: Podaj ostateczny wynik (np. 2:1)');

                if (penEl) {{
                    const rp = resultString.split(':');
                    if (rp.length === 2 && rp[0].trim() === rp[1].trim() && !penString) {{
                        return alert('To mecz pucharowy z remisem — podaj wynik karnych (np. 4:3).');
                    }}
                }}

                const homeTeam = homeEl ? (homeEl.dataset.team || '') : '';
                const awayTeam = awayEl ? (awayEl.dataset.team || '') : '';
                const splitField = (el) => (el && el.value.trim()) ? el.value.split(',').map(s => s.trim()).filter(s => s.length > 0) : [];
                const parseEntry = (raw) => {{
                    const parts = raw.trim().split(/\\s+/);
                    const last = parts[parts.length - 1];
                    if (parts.length > 1 && /^\\d+(\\+\\d+)?$/.test(last)) {{
                        return {{ name: parts.slice(0, -1).join(' '), minute: last }};
                    }}
                    return {{ name: raw.trim(), minute: null }};
                }};
                const homeParsed = splitField(homeEl).map(parseEntry);
                const awayParsed = splitField(awayEl).map(parseEntry);
                const allParsed = homeParsed.concat(awayParsed);
                const scorersArray = allParsed.map(x => x.name);
                const scorerTeamsArray = homeParsed.map(() => homeTeam).concat(awayParsed.map(() => awayTeam));
                const scorerMinutesArray = allParsed.map(x => x.minute);

                if (!confirm('Zapisać wynik ' + resultString + (penString ? ' (k.' + penString + ')' : '') + ' i rozliczyć punkty graczy?')) return;

                try {{
                    const response = await fetch('/matches/' + matchId + '/result', {{
                        method: 'PUT',
                        headers: {{ 'Content-Type': 'application/json', 'x-admin-secret': secret }},
                        body: JSON.stringify({{ result: resultString, scorers: scorersArray, scorer_teams: scorerTeamsArray, scorer_minutes: scorerMinutesArray, penalties: penString || null }})
                    }});

                    if (response.ok) {{
                        location.reload();
                    }} else {{
                        const errData = await response.json();
                        alert('Błąd serwera: ' + (errData.detail || 'Złe dane.'));
                    }}
                }} catch (err) {{ alert('Błąd sieci: ' + err.message); }}
            }}
        </script>
    </body>
    </html>
    """
    return html_content

@app.get("/admin/recalculate-all")
def recalculate_all_points(db: Session = Depends(get_db)):
    """Skrypt naprawczy w wersji rygorystycznej (brak typu = koniec serii)."""
    try:
        db.query(models.UserPick).filter(
            models.UserPick.match_id.in_(
                db.query(models.Match.id).filter(models.Match.stage != "group")
            )
        ).delete(synchronize_session=False)

        db.query(models.Match).filter(models.Match.stage != "group").delete(synchronize_session=False)
        db.commit()

        players = db.query(models.Player).all()
        for p in players:
            p.total_points = 0
            p.correct_predictions = 0
            p.current_streak = 0
            p.longest_streak = 0
            p.favorite_team_points = 0
            p.star_player_points = 0
        db.commit()

        finished_matches = db.query(models.Match).filter(
            models.Match.is_finished == True
        ).order_by(models.Match.match_date.asc(), models.Match.id.asc()).all()

        match_count = 0
        pick_count = 0

        for match in finished_matches:
            match_count += 1
            picks = db.query(models.UserPick).filter(models.UserPick.match_id == match.id).all()
            picks_by_player = {p.player_id: p for p in picks}
            
            for player in players:
                pick = picks_by_player.get(player.id)

                if pick:
                    pick_count += 1
                    pd = calculate_points_with_bonus(
                        pick.predicted_result, match.result, match.stage,
                        match.home_team, match.away_team, player.favorite_team,
                        player.star_player, match.scorers
                    )
                    match_total = pd["total_points"]

                    sb = 0
                    if pd["base_points"] > 0:
                        player.correct_predictions += 1
                        player.current_streak += 1
                        if player.current_streak > player.longest_streak:
                            player.longest_streak = player.current_streak
                        sb = streak_bonus(player.current_streak)
                    else:
                        player.current_streak = 0

                    grand_total = match_total + sb

                    pick.points_earned = grand_total
                    pick.points_breakdown = {
                        "base": pd["base_points"], "high_score": pd["high_score_bonus"], "underdog": pd["underdog_bonus"],
                        "favorite": pd["favorite_bonus"], "star": pd["star_player_bonus"], "multiplier": pd["multiplier"],
                        "streak_bonus": sb, "streak_len": player.current_streak,
                        "match_total": match_total, "grand_total": grand_total
                    }

                    player.total_points += grand_total
                    player.favorite_team_points += pd["favorite_bonus"]
                    player.star_player_points += pd["star_player_bonus"]
                else:
                    # KARYGODNE PRZEOCZENIE - zerujemy serię historycznie
                    player.current_streak = 0

            db.commit()

        advance_tournament_if_ready(db)

        return {
            "status": "success",
            "message": f"Przeliczono z użyciem surowych zasad serii! Meczów: {match_count}, Typów: {pick_count}."
        }
    except Exception as e:
        db.rollback()
        return {"status": "error", "message": f"Błąd krytyczny: {str(e)}"}