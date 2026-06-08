from sqlalchemy import Column, Integer, String, Boolean, DateTime, ForeignKey, JSON
from sqlalchemy.orm import relationship
from datetime import datetime
from database import Base

class Player(Base):
    __tablename__ = "players"
    id = Column(Integer, primary_key=True, index=True)
    username = Column(String, unique=True, index=True)
    full_name = Column(String, nullable=True)  # imię i nazwisko (widoczne dla admina i w profilu)
    email = Column(String, unique=True, index=True)
    password = Column(String, nullable=False)  # bcrypt hash
    is_active = Column(Boolean, default=True)
    is_alive = Column(Boolean, default=True)
    shields = Column(Integer, default=2)  # W UI wyświetlane jako "Rękawice"
    total_points = Column(Integer, default=0)
    correct_predictions = Column(Integer, default=0)
    favorite_team = Column(String, nullable=True)
    star_player = Column(String, nullable=True)
    created_at = Column(DateTime, default=datetime.utcnow) 

    # Nowe pola: system streaków i powrotów
    current_streak = Column(Integer, default=0)
    longest_streak = Column(Integer, default=0)
    comeback_points = Column(Integer, default=0)
    revival_used = Column(Boolean, default=False)
    favorite_locked = Column(Boolean, default=False)

    # Punkty zdobyte dzięki wyborowi reprezentacji i gwiazdy
    favorite_team_points = Column(Integer, default=0)
    star_player_points = Column(Integer, default=0)

    picks = relationship("UserPick", back_populates="player")

class Match(Base):
    __tablename__ = "matches"
    id = Column(Integer, primary_key=True, index=True)
    home_team = Column(String)
    away_team = Column(String)
    match_date = Column(DateTime)
    result = Column(String, nullable=True) 
    penalties = Column(String, nullable=True)  # wynik karnych przy remisie w fazie pucharowej, np. "4:3"
    is_locked = Column(Boolean, default=False)
    is_finished = Column(Boolean, default=False)
    stage = Column(String, default="group") 
    multiplier = Column(Integer, default=1)
    
    # FIX: brakująca kolumna z logów
    scorers = Column(JSON, default=list) 

    picks = relationship("UserPick", back_populates="match")

class UserPick(Base):
    __tablename__ = "user_picks"
    id = Column(Integer, primary_key=True, index=True)
    player_id = Column(Integer, ForeignKey("players.id"))
    match_id = Column(Integer, ForeignKey("matches.id"))
    predicted_result = Column(String)
    points_earned = Column(Integer, default=0)
    bonus_points = Column(Integer, default=0)
    points_breakdown = Column(JSON, nullable=True)  # rozkład punktów: za co dokładnie (typ, bonusy, seria)
    created_at = Column(DateTime, default=datetime.utcnow)

    player = relationship("Player", back_populates="picks")
    match = relationship("Match", back_populates="picks")