import os
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker, declarative_base

# POPRAWKA: dane logowania z zmiennych środowiskowych (ustawianych w docker-compose / .env)
# Nigdy nie hardcoduj haseł w kodzie!
DB_USER = os.environ.get("POSTGRES_USER", "admin")
DB_PASSWORD = os.environ.get("POSTGRES_PASSWORD", "admin")
DB_HOST = os.environ.get("POSTGRES_HOST", "db")
DB_PORT = os.environ.get("POSTGRES_PORT", "5432")
DB_NAME = os.environ.get("POSTGRES_DB", "world_cup_survivor")

SQLALCHEMY_DATABASE_URL = f"postgresql://{DB_USER}:{DB_PASSWORD}@{DB_HOST}:{DB_PORT}/{DB_NAME}"

engine = create_engine(SQLALCHEMY_DATABASE_URL)
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

Base = declarative_base()

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()