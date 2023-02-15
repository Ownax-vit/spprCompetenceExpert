from app.db import Database


if __name__ == '__main__':
    m = Database()
    m.get_all_requirements()
    m.get_all_tasks_for_requirement("competence")
    m.get_all_answers_for_task(1)
