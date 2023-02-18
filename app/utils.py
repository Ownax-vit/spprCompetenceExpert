

def transform_mark_requirement_to_dict(mark_requirement: list[tuple]) -> dict:
    """ Преобразование в словарь данных оценок и экспертов для виджета таблицы """
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
    dict_mark_competence = get_dict_weight_comp(mark_requirement)
    dict_res_mark = get_dict_result_mark(dict_mark, dict_mark_competence)
    dict_mark["Итого"] = dict_res_mark

    return dict_mark


def get_dict_weight_comp(mark_requirement: list[tuple]) -> dict:
    """ Получить словарь весов компетенции """
    """ {"Оценка комп1: 0.2, Оценка комп2: 0.3} """
    dict_mark_comp = {}
    for record in mark_requirement:
        if not dict_mark_comp.get(record[0]):
            dict_mark_comp[record[0]] = record[1]

    return dict_mark_comp


def get_dict_expert_id_name(dict_mark_requirement: dict) -> dict:
    """ Получить словарь имен экспертов по ид """
    """ {expert_id: name, expert_id: name} """
    dict_expert_id_name = {}
    for competence, competence_dict in dict_mark_requirement.items():
        for expert_id in competence_dict.keys():
            if expert_id not in dict_expert_id_name.keys():
                dict_expert_id_name[expert_id] = dict_mark_requirement[competence][expert_id]["first_name"] +\
                    " " + dict_mark_requirement[competence][expert_id]["last_name"]
    return dict_expert_id_name


def get_list_id_experts(dict_mark_requirement: dict) -> list:
    """ Получить список ид экспертов """
    list_id = []
    for competence, competence_dict in dict_mark_requirement.items():
        for expert_id in competence_dict.keys():
            list_id.append(expert_id)

    list_id = set(list_id)
    return list_id


def get_dict_result_mark(dict_mark_requirement: dict, dict_mark_competence: dict) -> dict:
    """ Получить словарь итоговой оценки для экспертов """
    list_experts = get_list_id_experts(dict_mark_requirement)
    dict_res_mark = {}
    for i in list_experts:
        res_mark = 0
        for comp, expert in dict_mark_requirement.items():
            if not dict_mark_requirement[comp].get(i):
                mark_for_comp = 0
            else:
                mark_for_comp = dict_mark_requirement[comp][i]["mark"]
            res_mark += dict_mark_competence[comp] * mark_for_comp
        dict_res_mark[i] = round(res_mark, 2)

    return dict_res_mark



