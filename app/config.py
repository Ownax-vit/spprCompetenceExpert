from dataclasses import dataclass


@dataclass
class Config:
    name_db: str = "db_lite.db"

