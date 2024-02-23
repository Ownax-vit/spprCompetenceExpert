import sqlite3

from app.config import Config
from scripts.data import init_data

def main():
    name_db = Config.name_db
    print("creating db ..")

    data_sql = init_data
    pathTodb = f"{name_db}"

    engine = sqlite3.connect(pathTodb)
    session = engine.cursor()
    session.executescript(data_sql)

    engine.commit()
    session.close()
    print("db created.")


if __name__ == '__main__':
    main()