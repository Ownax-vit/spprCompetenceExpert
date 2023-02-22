import os
import sqlite3

from app.config import Config


def main():
    name_db = Config.name_db
    dir_path = os.path.dirname(os.path.realpath(__file__))
    print("creating db ..")
    with open("data.sql", "r", encoding='utf-8') as file:
        data_sql = file.read()

    pathTodb = '\\'.join(dir_path.split('\\')[:-1])
    pathTodb += f"\\{name_db}"

    engine = sqlite3.connect(pathTodb)
    session = engine.cursor()
    session.executescript(data_sql)

    engine.commit()
    session.close()
    print("db created.")


if __name__ == '__main__':
    main()