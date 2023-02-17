

def transform_mark_requirement_to_dict(mark_requirement: list[tuple]) -> dict:
    """ Преобразование в словарь данных оценок и экспертов для виджета таблицы"""
    """ {"Оценка проф.": {4: {"first_name":"Петя", "last_name":"Иванов", "mark": 0.3}, ... }, ...}"""
    dict_mark = {}
    for record in mark_requirement:
        if not dict_mark.get(record[0]):
            dict_mark[record[0]] = {}
        dict_mark[record[0]][record[2]] = {
            "first_name": record[4],
            "last_name": record[5],
            "mark": record[3]
        }
    return dict_mark


def get_dict_expert_id_name(dict_mark_requirement: dict) -> dict:
    """ {expert_id: name, expert_id: name} """
    dict_expert_id_name = {}
    for competence, competence_dict in dict_mark_requirement.items():
        for expert_id in competence_dict.keys():
            if expert_id not in dict_expert_id_name.keys():
                dict_expert_id_name[expert_id] = dict_mark_requirement[competence][expert_id]["first_name"] +\
                    " " + dict_mark_requirement[competence][expert_id]["last_name"]
    return dict_expert_id_name


def get_list_id_experts(dict_mark_requirement: dict) -> list:
    list_id = []
    for competence, competence_dict in dict_mark_requirement.items():
        for expert_id in competence_dict.keys():
            list_id.append(expert_id)

    list_id = set(list_id)
    return list_id

