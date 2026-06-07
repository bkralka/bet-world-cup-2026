#!/usr/bin/env python3
"""
Pełna symulacja Mistrzostw Świata 2026 (48 drużyn, 12 grup, 1/16 finału).
- Generuje wyniki grupowe i pucharowe.
- Tworzy przykładowych graczy i ich typy (losowe).
- Przelicza punkty i aktualizuje ranking.
- Modyfikuje szablon index.html, aby wyświetlał wszystkie mecze.
"""

import sys
import os
import random
from datetime import datetime, timedelta
from sqlalchemy.orm import Session
from sqlalchemy import text
from database import SessionLocal, engine
import models
from main import (
    now_utc, STAGE_MULTIPLIERS, calculate_group_standings,
    TEAM_TO_GROUP, GROUPS_LIST, calculate_points_with_bonus,
    hash_password
)

# ============================================================
# KONFIGURACJA
# ============================================================
NUM_PLAYERS = 5
RANDOM_SEED = 42
CLEAN_START = True          # usuń istniejące typy, wyniki i mecze pucharowe
CREATE_PICKS = True
SET_RESULTS = True

random.seed(RANDOM_SEED)

# ============================================================
# POMOCNICZE
# ============================================================
def generate_result():
    """Losuje realistyczny wynik meczu (z przewagą gospodarza)."""
    r = random.random()
    if r < 0.45:
        h = random.randint(1, 3)
        a = random.randint(0, h - 1)
    elif r > 0.75:
        a = random.randint(1, 3)
        h = random.randint(0, a - 1)
    else:
        h = random.randint(0, 2)
        a = h
    return f"{h}:{a}"

def ensure_columns():
    """Dodaje brakujące kolumny w tabeli players (jeśli nie istnieją)."""
    with engine.connect() as conn:
        result = conn.execute(text("SELECT column_name FROM information_schema.columns WHERE table_name='players'"))
        cols = {row[0] for row in result}
        if 'favorite_team_points' not in cols:
            conn.execute(text("ALTER TABLE players ADD COLUMN favorite_team_points INTEGER DEFAULT 0"))
            print("Dodano kolumnę favorite_team_points")
        if 'star_player_points' not in cols:
            conn.execute(text("ALTER TABLE players ADD COLUMN star_player_points INTEGER DEFAULT 0"))
            print("Dodano kolumnę star_player_points")
        conn.commit()

def get_team_from_group_position(db, group, position):
    """Zwraca nazwę drużyny, która zajęła daną pozycję w grupie (1,2,3)."""
    standings = calculate_group_standings(db)
    teams = standings.get(group, [])
    if position <= len(teams):
        return teams[position - 1]['name']
    return None

def get_qualified_teams(db):
    """
    Zwraca listę (nazwa_drużyny, (grupa, pozycja)) dla wszystkich 32 drużyn,
    które awansują do 1/16 finału według zasad MŚ 2026.
    """
    group_standings = calculate_group_standings(db)
    qualified = []
    third_place = []

    for group in GROUPS_LIST:
        teams = group_standings.get(group, [])
        # pierwsze dwa miejsca
        for pos in (1, 2):
            if len(teams) >= pos:
                qualified.append((teams[pos-1]['name'], (group, pos)))
        # trzecie miejsce
        if len(teams) >= 3:
            t = teams[2]
            third_place.append((t['name'], (group, 3), t['points'], t['goal_diff'], t['goals_for']))

    # sortuj trzecie miejsca: punkty > różnica bramek > strzelone bramki
    third_place.sort(key=lambda x: (x[2], x[3], x[4]), reverse=True)
    best_third = third_place[:8]
    for team, group_pos, _, _, _ in best_third:
        qualified.append((team, group_pos))

    return qualified

def build_knockout_bracket(qualified_teams):
    """
    Tworzy pary 1/16 finału według oficjalnego klucza MŚ 2026.
    Zwraca listę meczów [(gospodarz, gość), ...] w kolejności od 1/16 do finału.
    """
    # Mapa: dla każdej grupy zapamiętaj nazwę zwycięzcy (1) i wicemistrza (2)
    winners = {}
    runners = {}
    for team, (group, pos) in qualified_teams:
        if pos == 1:
            winners[group] = team
        elif pos == 2:
            runners[group] = team

    # Oficjalne pary 1/16 finału (na podstawie dokumentacji FIFA 2026)
    # Źródło: https://en.wikipedia.org/wiki/2026_FIFA_World_Cup_knockout_stage
    round32_pairs = [
        ('A1', 'B2'), ('C1', 'D2'), ('E1', 'F2'), ('G1', 'H2'),
        ('I1', 'J2'), ('K1', 'L2'), ('B1', 'A2'), ('D1', 'C2'),
        ('F1', 'E2'), ('H1', 'G2'), ('J1', 'I2'), ('L1', 'K2'),
        # Pary z udziałem najlepszych trzecich miejsc – dla uproszczenia łączymy je z wolnymi zwycięzcami
        # W pełnej wersji trzeba by określić, które trzecie miejsca trafiają do których par.
        # Tutaj zastosuję heurystykę: bierzemy pozostałe drużyny (trzecie miejsca) i dobieramy w pary.
    ]
    # Zbierz wszystkie drużyny, które mają przypisane miejsce (1 lub 2)
    assigned = set()
    matches = []
    for code1, code2 in round32_pairs:
        g1, p1 = code1[0], int(code1[1])
        g2, p2 = code2[0], int(code2[1])
        team1 = winners.get(g1) if p1 == 1 else runners.get(g1)
        team2 = winners.get(g2) if p2 == 1 else runners.get(g2)
        if team1 and team2:
            matches.append((team1, team2))
            assigned.add(team1)
            assigned.add(team2)

    # Dodaj trzecie miejsca – pozostałe zakwalifikowane drużyny (które nie są w assigned)
    remaining = [team for team, _ in qualified_teams if team not in assigned]
    # Przemieszaj i dobierz w pary
    random.shuffle(remaining)
    for i in range(0, len(remaining), 2):
        if i+1 < len(remaining):
            matches.append((remaining[i], remaining[i+1]))
    # Jeśli potrzeba, uzupełnij do 16 par (zazwyczaj będzie 16)
    while len(matches) < 16:
        matches.append(("Dummy", "Dummy"))  # nie powinno się zdarzyć
    return matches[:16]

def create_match(db, home, away, stage, match_date, multiplier):
    """Tworzy pojedynczy mecz pucharowy, jeśli jeszcze nie istnieje."""
    existing = db.query(models.Match).filter(
        models.Match.home_team == home,
        models.Match.away_team == away,
        models.Match.stage == stage
    ).first()
    if existing:
        return existing
    match = models.Match(
        home_team=home,
        away_team=away,
        match_date=match_date,
        stage=stage,
        multiplier=multiplier,
        is_locked=False,
        is_finished=False,
        result=None
    )
    db.add(match)
    db.commit()
    return match

def create_round_of_32(db, qualified_teams):
    """Tworzy mecze 1/16 finału."""
    pairs = build_knockout_bracket(qualified_teams)
    base_date = datetime(2026, 6, 29, 18, 0)  # data startu fazy pucharowej
    matches = []
    for i, (home, away) in enumerate(pairs):
        match_date = base_date + timedelta(days=i//4, hours=(i%4)*3)
        match = create_match(db, home, away, "round_32", match_date, STAGE_MULTIPLIERS.get("round_32", 1))
        matches.append(match)
    return matches

def simulate_round(db, stage_name, next_stage_name=None):
    """Symuluje rundę pucharową, zapisuje wyniki i tworzy pary do następnej rundy."""
    matches = db.query(models.Match).filter(models.Match.stage == stage_name, models.Match.is_finished == False).all()
    if not matches:
        return []

    winners = []
    for match in matches:
        result = generate_result()
        match.result = result
        match.is_finished = True
        match.is_locked = True
        db.commit()
        print(f"  {stage_name}: {match.home_team} {result} {match.away_team}")
        h, a = map(int, result.split(':'))
        winner = match.home_team if h > a else match.away_team
        winners.append(winner)

    # Jeśli nie ma następnej rundy lub liczba zwycięzców jest nieparzysta – koniec
    if not next_stage_name or len(winners) < 2:
        return winners

    # Utwórz pary do następnej rundy
    next_matches = []
    base_date = matches[0].match_date + timedelta(days=3) if matches else datetime.now()
    for i in range(0, len(winners), 2):
        if i+1 < len(winners):
            home = winners[i]
            away = winners[i+1]
            match_date = base_date + timedelta(days=i//2)
            match = create_match(db, home, away, next_stage_name, match_date, STAGE_MULTIPLIERS.get(next_stage_name, 1))
            next_matches.append(match)
    return winners

def create_third_place_match(db, semi_winners):
    """Tworzy i symuluje mecz o 3. miejsce między przegranymi półfinałów."""
    # Pobierz przegranych półfinałów
    semi_matches = db.query(models.Match).filter(models.Match.stage == "semi", models.Match.is_finished == True).all()
    if len(semi_matches) != 2:
        return
    losers = []
    for match in semi_matches:
        h, a = map(int, match.result.split(':'))
        loser = match.away_team if h > a else match.home_team
        losers.append(loser)
    # Data finału + 1 dzień
    final_match = db.query(models.Match).filter(models.Match.stage == "final").first()
    if not final_match:
        return
    third_date = final_match.match_date + timedelta(days=1)
    third_match = create_match(db, losers[0], losers[1], "third_place", third_date, STAGE_MULTIPLIERS.get("third_place", 2))
    result = generate_result()
    third_match.result = result
    third_match.is_finished = True
    third_match.is_locked = True
    db.commit()
    print(f"  Mecz o 3. miejsce: {losers[0]} {result} {losers[1]}")

# ============================================================
# GŁÓWNA SYMULACJA
# ============================================================
def main():
    db = SessionLocal()
    try:
        ensure_columns()

        if CLEAN_START:
            print("Czyszczenie danych...")
            db.query(models.UserPick).delete()
            db.query(models.Match).filter(models.Match.stage != "group").delete()
            db.query(models.Match).update({models.Match.result: None, models.Match.is_finished: False, models.Match.is_locked: False})
            db.commit()

        # 1. Tworzenie graczy
        for i in range(1, NUM_PLAYERS+1):
            username = f"sim_{i}"
            if not db.query(models.Player).filter(models.Player.username == username).first():
                hashed = hash_password("pass123")
                player = models.Player(username=username, password=hashed, email=f"{username}@sim.pl")
                db.add(player)
        db.commit()
        print(f"Utworzono {NUM_PLAYERS} graczy.")


                # ------------------------------------------------------------
        # PRZYPISANIE ULUBIONYCH DRUŻYN I GWIAZD DLA GRACZY
        # ------------------------------------------------------------
        # Tutaj zdefiniuj, które drużyny i gwiazdy mają trafić do poszczególnych graczy
        # Indeksy: sim_1, sim_2, sim_3, sim_4, sim_5
        przypisane_druzyny = [
            "Francja",
            "Argentyna",
            "Brazylia",
            "Portugalia",
            "Holandia"
        ]
        przypisane_gwiazdy = [
            "Kylian Mbappé",
            "Lionel Messi",
            "Vinícius Júnior",
            "Cristiano Ronaldo",
            "Cody Gakpo"
        ]

        # Pobierz utworzonych graczy (zakładamy, że są to sim_1..sim_N)
        nowi_gracze = db.query(models.Player).filter(models.Player.username.like("sim_%")).order_by(models.Player.id).all()
        for idx, player in enumerate(nowi_gracze):
            if idx < len(przypisane_druzyny):
                player.favorite_team = przypisane_druzyny[idx]
                player.star_player = przypisane_gwiazdy[idx]
                player.favorite_locked = True   # blokujemy możliwość zmiany
        db.commit()
        print("Przypisano drużyny i gwiazdy dla graczy.")

        # 2. Typy na mecze grupowe
        if CREATE_PICKS:
            players = db.query(models.Player).all()
            group_matches = db.query(models.Match).filter(models.Match.stage == "group").all()
            for player in players:
                for match in group_matches:
                    if not db.query(models.UserPick).filter_by(player_id=player.id, match_id=match.id).first():
                        pick = models.UserPick(player_id=player.id, match_id=match.id, predicted_result=generate_result())
                        db.add(pick)
                db.commit()
            print(f"Utworzono typy dla {len(players)} graczy na {len(group_matches)} meczów grupowych.")

        # 3. Wyniki grupowe
        if SET_RESULTS:
            group_matches = db.query(models.Match).filter(models.Match.stage == "group").order_by(models.Match.match_date).all()
            for match in group_matches:
                if match.result is None:
                    result = generate_result()
                    match.result = result
                    match.is_finished = True
                    match.is_locked = True
                    db.commit()
                    print(f"Grupa: {match.home_team} {result} {match.away_team}")

        # 4. Kwalifikacje do fazy pucharowej
        qualified = get_qualified_teams(db)
        print(f"Zakwalifikowano {len(qualified)} drużyn do 1/16 finału.")

        # 5. Tworzenie meczów 1/16
        round32_matches = create_round_of_32(db, qualified)
        print(f"Utworzono {len(round32_matches)} meczów 1/16 finału.")

        # 6. Typy na mecze pucharowe
        if CREATE_PICKS:
            knockout_matches = db.query(models.Match).filter(models.Match.stage != "group").all()
            players = db.query(models.Player).all()
            for player in players:
                for match in knockout_matches:
                    if not db.query(models.UserPick).filter_by(player_id=player.id, match_id=match.id).first():
                        pick = models.UserPick(player_id=player.id, match_id=match.id, predicted_result=generate_result())
                        db.add(pick)
                db.commit()
            print(f"Dodano typy na {len(knockout_matches)} meczów pucharowych.")

        # 7. Symulacja rund pucharowych
        if SET_RESULTS:
            print("\nSymulacja 1/16 finału...")
            simulate_round(db, "round_32", "round_16")
            print("\nSymulacja 1/8 finału...")
            simulate_round(db, "round_16", "quarter")
            print("\nSymulacja ćwierćfinałów...")
            simulate_round(db, "quarter", "semi")
            print("\nSymulacja półfinałów...")
            simulate_round(db, "semi", "final")
            print("\nSymulacja finału...")
            simulate_round(db, "final", None)
            print("\nMecz o 3. miejsce...")
            create_third_place_match(db, None)

        # 8. Przeliczenie punktów dla wszystkich typów
        picks = db.query(models.UserPick).all()
        for pick in picks:
            match = db.query(models.Match).get(pick.match_id)
            if not match or not match.result:
                continue
            player = db.query(models.Player).get(pick.player_id)
            if not player:
                continue
            points_data = calculate_points_with_bonus(
                pick.predicted_result, match.result, match.stage,
                match.home_team, match.away_team, player.favorite_team,
                player.star_player, match.scorers or []
            )
            pick.points_earned = points_data["total_points"]
            # Aktualizacja statystyk gracza
            player.total_points += points_data["total_points"]
            player.favorite_team_points += points_data.get("favorite_bonus", 0)
            player.star_player_points += points_data.get("star_player_bonus", 0)
            if points_data["base_points"] > 0:
                player.correct_predictions += 1
                player.current_streak += 1
                if player.current_streak > player.longest_streak:
                    player.longest_streak = player.current_streak
            else:
                player.current_streak = 0
            db.commit()
        print("Przeliczono punkty dla wszystkich typów.")

        # 9. Modyfikacja szablonu (opcjonalnie)
        template_path = "/app/templates/index.html"
        if os.path.exists(template_path):
            with open(template_path, 'r', encoding='utf-8') as f:
                content = f.read()
            if '{% set future_matches = matches | selectattr("is_finished", "equalto", false) | list %}' in content:
                content = content.replace(
                    '{% set future_matches = matches | selectattr("is_finished", "equalto", false) | list %}',
                    '{% set future_matches = matches %}'
                )
                with open(template_path, 'w', encoding='utf-8') as f:
                    f.write(content)
                print("Zaktualizowano szablon HTML – teraz pokazuje wszystkie mecze.")
            else:
                print("Szablon już zmodyfikowany lub nie zawiera oczekiwanego wzorca.")
        else:
            print("Plik szablonu nie znaleziony.")

        print("\n✅ Symulacja zakończona! Odśwież stronę http://localhost:8000")

    except Exception as e:
        print(f"Błąd: {e}")
        import traceback
        traceback.print_exc()
    finally:
        db.close()

if __name__ == "__main__":
    main()