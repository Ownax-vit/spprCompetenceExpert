import os
import sqlite3 as db
from sqlite3 import Error as ErrorDb
from typing import Optional, Iterable

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
        query = """SELECT requirement_name, name, description, weight FROM requirements"""
        self.cur.execute(query)
        res = self.cur.fetchall()
        print(res)
        return res

    def get_all_tasks_for_requirement(self, requirement_name: str) -> Optional[list[tuple]]:

        query = """
            SELECT task_id, requirement_name, task_type, name, description, weight FROM tasks 
            WHERE requirement_name = ?
        """

        self.cur.execute(query, (requirement_name,))
        res = self.cur.fetchall()
        print(res)
        return res

    def get_all_solution_for_task(self, task_id: int) -> Optional[list[tuple]]:
        query = """
              SELECT solution_id, task_id, mark, text, valid_answer FROM solutions WHERE task_id = ?
          """
        self.cur.execute(query, (task_id,))
        res = self.cur.fetchall()

        return res

    def get_all_experts(self) -> Optional[list[tuple]]:
        query = """
              SELECT expert_id, first_name, last_name FROM experts
          """
        self.cur.execute(query)
        res = self.cur.fetchall()

        return res

    def add_expert(self, f_name: str, l_name: str):
        query = """
              INSERT INTO experts (first_name, last_name) VALUES (?, ?)
          """
        self.cur.execute(query, (f_name, l_name))
        self.con.commit()

    def add_answer(self, solution_id: int, expert_id: int, mark: float):
        query = """
             INSERT INTO answers (solution_id, expert_id, mark) VALUES (?, ?)
        """

    def add_mark_requirement(self, expert_id: int, requirement_name: str, mark: float):
        query = """
              INSERT INTO mark_requirement (expert_id, requirement_name, mark) VALUES (?, ?, ?)

          """
        self.cur.execute(query, (expert_id, requirement_name, mark))
        self.con.commit()

    def get_all_marks_requirements_experts(self):
        query = """
              SELECT r.name, r.weight, m_r.expert_id, m_r.mark, e.first_name, e.last_name from requirements r
              INNER JOIN mark_requirement m_r on r.requirement_name=m_r.requirement_name
              INNER JOIN experts e on e.expert_id=m_r.expert_id ORDER BY m_r.expert_id
              
          """
        self.cur.execute(query)
        res = self.cur.fetchall()

        return res

    def get_count_experts(self) -> int:
        query = """
              SELECT COUNT(*) FROM experts

          """
        try:
            self.cur.execute(query)
            res = int(self.cur.fetchone()[0])
        except Exception as exc:
            res = 0
        return res

    def clear_results(self):
        query = """
                 DELETE FROM mark_requirement

             """
        self.cur.execute(query)
        self.con.commit()






