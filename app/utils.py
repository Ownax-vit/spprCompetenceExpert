


def transform_mark_requirement_to_dict(mark_requirement: list[tuple]) -> dict:
    """ Преобразование в словарь данных оценок и экспертов для виджета таблицы"""
    dict_mark = {}
    for record in mark_requirement:
        if not dict_mark.get(record[0]):
            dict_mark[record[0]] = {}
        dict_mark[record[0]][2] = {
            dict_mark["first_name"]: record[4],
            dict_mark["last_name"]: record[5],
            dict_mark["mark"]: record[3]
        }
    return dict_mark
