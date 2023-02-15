import os
import sqlite3

from app.config import Config


def main():
    name_db = Config.name_db
    dir_path = os.path.dirname(os.path.realpath(__file__))

    pathTodb = '\\'.join(dir_path.split('\\')[:-1])
    pathTodb += f"\\{name_db}"

    engine = sqlite3.connect(pathTodb)
    session = engine.cursor()

    session.execute("""
        create table experts(
            expert_id integer not null primary key autoincrement,
            first_name varchar(256) not null,
            last_name varchar(256) not null,
            result_mark decimal
        );
    """)
    session.execute("""
           create table requirements(
               requirement_name varchar(256) not null primary key,
               name varchar(256) not null,
               description varchar(256) not null,
               weigth decimal
           );
       """)
    session.execute("""
           create table task_type(
               task_type_id integer not null primary key autoincrement,
               name varchar(256),
               description varchar(512)
           );
       """)
    session.execute("""
           create table tasks(
               task_id integer not null primary key autoincrement,
               requirement_name varchar(256) references requirements ON DELETE CASCADE ON UPDATE CASCADE,
               type_task_id integer references task_type ON DELETE CASCADE ON UPDATE CASCADE,
               name varchar(256),
               description varchar(512)
           );
       """)

    session.execute("""
         create table answers(
             answer_id integer not null primary key autoincrement,
             task_id integer references tasks ON DELETE CASCADE ON UPDATE CASCADE,
             mark decimal,
             text varchar(256)
         );
     """)

    session.execute("""
         create table solutions(
             solution_id integer not null primary key autoincrement,
             expert_id integer references experts ON DELETE CASCADE ON UPDATE CASCADE,
             answer_id integer references answers ON DELETE CASCADE ON UPDATE CASCADE
         );
     """)
    session.close()


if __name__ == '__main__':
    main()