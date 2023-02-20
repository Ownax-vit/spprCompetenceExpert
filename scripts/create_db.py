import os
import sqlite3

from app.config import Config


def main():
    name_db = Config.name_db
    dir_path = os.path.dirname(os.path.realpath(__file__))

    with open("data.sql", "r", encoding='utf-8' ) as file:
        data_sql = file.read()

    pathTodb = '\\'.join(dir_path.split('\\')[:-1])
    pathTodb += f"\\{name_db}"

    engine = sqlite3.connect(pathTodb)
    session = engine.cursor()
    session.executescript(data_sql)
    #
    # session.execute("""
    #     create table experts(
    #         expert_id integer not null primary key autoincrement,
    #         first_name varchar(255) not null,
    #         last_name varchar(255) not null
    #     );
    # """)
    # session.execute("""
    #        create table requirements(
    #            requirement_name varchar(255) not null primary key,
    #            name varchar(255) not null,
    #            description varchar(255) not null,
    #            weight decimal not null
    #        );
    #    """)
    # session.execute("""
    #        create table task_type(
    #            task_type varchar(255) not null primary key,
    #            name varchar(255) not null,
    #            description varchar(512)
    #        );
    #    """)
    # session.execute("""
    #        create table tasks(
    #            task_id integer not null primary key autoincrement,
    #            requirement_name varchar(255) references requirements ON DELETE CASCADE ON UPDATE CASCADE,
    #            task_type varchar(255) references task_type ON DELETE CASCADE ON UPDATE CASCADE,
    #            name varchar(255) not null,
    #            description varchar(512)
    #        );
    #    """)
    #
    # session.execute("""
    #      create table solutions(
    #          solution_id integer not null primary key autoincrement,
    #          task_id integer references tasks ON DELETE CASCADE ON UPDATE CASCADE,
    #          mark decimal not null,
    #          text varchar(255),
    #          valid_answer varchar(255) default null
    #      );
    #  """)
    #
    # session.execute("""
    #      create table answers(
    #          answer_id integer not null primary key autoincrement,
    #          expert_id integer references experts ON DELETE CASCADE ON UPDATE CASCADE,
    #          solution_id integer references answers ON DELETE CASCADE ON UPDATE CASCADE
    #      );
    #  """)
    # session.execute("""
    #      create table mark_requirement(
    #          mark_requirement_id integer not null primary key autoincrement,
    #          expert_id integer references experts ON DELETE CASCADE ON UPDATE CASCADE,
    #          requirement_name varchar(255) references requirements ON DELETE CASCADE ON UPDATE CASCADE,
    #          mark decimal not null
    #
    #      );
    #  """)
    engine.commit()
    session.close()


if __name__ == '__main__':
    main()