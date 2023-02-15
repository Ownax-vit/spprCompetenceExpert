import os
import sqlite3 as db
from sqlite3 import Error as ErrorDb
from typing import Optional, Iterable

from .models import Expert
from .config import Config


class Database:
    def __init__(self, db_path: str = None):
        self.db_path = db_path or Config.name_db
        try:
            self.con = db.connect(self.db_path)
            self.cur = self.con.cursor()
        except (Exception, ErrorDb) as exc:
             print("Error connect to db", exc)
             os.exit(1)

    def __del__(self):
        self.con.close()

    def get_all_requirements(self) -> Optional[list[tuple]]:
        """ Получить все требования для оценки, вкладки"""
        query = """SELECT requirement_name, name, description, weigth FROM requirements"""
        self.cur.execute(query)
        res = self.cur.fetchall()
        print(res)
        return res

    def get_all_tasks_for_requirement(self, requirement_name: str) -> Optional[list[tuple]]:

        query = """
            SELECT task_id, requirement_name, type_task_id, name, description FROM tasks 
            WHERE requirement_name = ?
        """

        self.cur.execute(query, (requirement_name,))
        res = self.cur.fetchall()
        print(res)
        return res

    def get_all_answers_for_task(self, task_id: int) -> Optional[list[tuple]]:
        query = """
              SELECT answer_id, task_id, mark, text FROM answers WHERE task_id = ?
          """
        self.cur.execute(query, (task_id,))
        res = self.cur.fetchall()

        return res
