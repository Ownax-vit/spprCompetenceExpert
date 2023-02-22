import numpy as np
from PyQt6.QtWidgets import QWidget, QScrollArea, QBoxLayout, \
    QVBoxLayout, QRadioButton, QGroupBox, QLabel, QPushButton, QCheckBox, QComboBox, \
    QTableWidget, QTableWidgetItem, QLineEdit, QHBoxLayout, QSpacerItem, QSizePolicy, QMessageBox
from PyQt6.QtGui import QColor

from .db import Database
from .utils import transform_mark_requirement_to_dict, get_list_id_experts, get_dict_expert_id_name


class Result(QWidget):
    """
        Класс вкладки результатов, отображет
        таблицу результатов всех экспертов, выводит график
    """

    def __init__(self):
        super().__init__()
        self.db = Database()
        self.list_marks_requirement = None
        self.dict_marks_requirement = None
        self.init_data_marks()
        self.vbox_main = QVBoxLayout()

        self.render()

    def init_data_marks(self):
        self.list_marks_requirement = self.db.get_all_marks_requirements_experts()
        self.dict_marks_requirement = transform_mark_requirement_to_dict(self.list_marks_requirement)

    def render(self):
        """ Рендер вкладки результатов """

        btn_update = QPushButton("Обновить")
        btn_update.setFixedHeight(40)
        btn_update.setFixedWidth(150)
        btn_update.clicked.connect(self.update_result_data)
        self.vbox_main.addWidget(btn_update)

        table = self.render_table()

        self.vbox_main.addWidget(table)
        self.setLayout(self.vbox_main)

    def render_table(self) -> QTableWidget:
        """ Рендер таблицы результатов по компетенциям / экспертам и итоговых данных """
        self.init_data_marks()  # обновить данные оценок из БД
        dict_expert_name_id = get_dict_expert_id_name(self.dict_marks_requirement)
        list_id_experts_in_dict = sorted(get_list_id_experts(self.dict_marks_requirement))
        list_name_experts = list(dict_expert_name_id[i] for i in list_id_experts_in_dict)

        table = QTableWidget(self)

        count_rows = len(self.dict_marks_requirement.keys())  # плюс последняя строка - глобал оценка
        count_cols = int(len(list_id_experts_in_dict))

        table.setRowCount(count_rows)  # количество компетенций (вкладок)
        table.setColumnCount(count_cols)  # количество экспертов

        table.setHorizontalHeaderLabels(list_name_experts)
        table.setVerticalHeaderLabels(list(self.dict_marks_requirement.keys()))

        # заполнение таблицы
        for i, (competence, data) in enumerate(self.dict_marks_requirement.items()):
            for j, expert_id in enumerate(list_id_experts_in_dict):
                expert_data = self.dict_marks_requirement[competence].get(expert_id)
                if expert_data is None:
                    mark = 0
                else:
                    mark = expert_data.get("mark") if competence != "Итого" else \
                        self.dict_marks_requirement[competence].get(expert_id)
                cell = QTableWidgetItem(str(mark))
                if competence == "Итого":
                    cell.setBackground(QColor(217, 217, 217))
                table.setItem(i, j, cell)

        return table
        print(exc)
        # self.db.clear_results()

    def clear_vbox(self):
        """ Очистить вкладку """
        if self.vbox_main is not None:
            while self.vbox_main.count():
                item = self.vbox_main.takeAt(0)
                widget = item.widget()
                if widget is not None:
                    widget.deleteLater()
                else:
                    self.deleteLayout(item.layout())

    def update_result_data(self):
        """ Обновить данные """
        self.clear_vbox()
        self.render()


class Requirement(QWidget):
    """ Конкретная оценка компетенции к эксперту, представляет собой вкладку в окне"""
    def __init__(self, current_expert: str, name: str, description: str, weight: float):
        super().__init__()

        self.db = Database()
        self.current_expert = current_expert  # текущий оцениваемый эксперт
        self.name = name                      # наименование вкладки из БД
        self.description = description        # описание вкладки из БД
        self.weight = weight                  # глобальный вес компетенции
        self.mark_label = QLabel("0")         # текущая оценка компетенции

        self.vbox_main = QVBoxLayout()

        # словарь типов задач
        self.dict_types_tasks = {"question_variant": self.render_variant,
                           "check_multiple": self.render_check_multiple,
                           "question_input": self.render_input,
                           "question_combobox": self.render_combobox,
                           # "question_checkbox": self.render_checkbox,
                           # "question_input": self.render_input
                           }
        self.dict_answer_to_solution = {}
        self.render()

    def render(self):
        """ Рендер всей вкладки - все задачи, все ответы для задач """
        all_tasks = self.db.get_all_tasks_for_requirement(self.name)
        scroll_area = QScrollArea()  # скролл
        widget_tab = QWidget()
        vbox = QVBoxLayout()


        descript = QLabel(self.description)
        vbox.addWidget(descript)

        # vertical_spacer = QSpacerItem(20, 40)
        for task in all_tasks:
            task_box = self.render_task(task)
            vbox.addWidget(task_box)
            # vbox.addSpacerItem(vertical_spacer)

        btn_send = QPushButton("Отправить")     # кнопка подсчета оценки компетенции
        btn_send.setFixedHeight(40)
        btn_send.setFixedWidth(150)
        btn_send.clicked.connect(self.calc_tab_mark)
        vbox.addWidget(btn_send, 5)

        vbox.addWidget(QLabel("Текущая оценка: "))
        vbox.addWidget(self.mark_label)

        widget_tab.setLayout(vbox)
        scroll_area.setWidgetResizable(True)
        scroll_area.setWidget(widget_tab)
        self.vbox_main.addWidget(scroll_area)
        self.setLayout(self.vbox_main)

    def render_task(self, task: list) -> QGroupBox:
        """Рендер задачи c ответами"""
        """ task_id, requirement_name, task_type, name, description """

        group_box = QGroupBox(task[3])
        solutions = self.db.get_all_solution_for_task(task[0])

        type_task = self.dict_types_tasks.get(task[2]) # получение метода рендеринга в зависимости от типа задачи
        if type_task is None:
            raise Exception("Не существует задачи в БД")
        vbox_answers = type_task(solutions)       # рендеринг по соответствующему методу

        group_box.setLayout(vbox_answers)

        return group_box

    def render_variant(self, answers: list) -> QVBoxLayout():
        """ Рендер ответов в виде обычного выбора варианта """
        vbox_solution = QVBoxLayout()

        for answer in answers:
            radio = QRadioButton(answer[3])     # Кнопка ответа с соответствующим текстом
            radio.setStyleSheet("QRadioButton"
                                       "{"
                                       "spacing : 20px;"
                                       "}")
            radio.mark = answer[2]              # оценка за данный ответ
            radio.task_id = answer[1]           # ид задачи (вопроса)
            radio.solution_id = answer[0]       # ид ответа
            radio.clicked.connect(self.assign_mark_to_answer)
            vbox_solution.addWidget(radio)

        return vbox_solution

    def render_check_multiple(self, answers: list) -> QVBoxLayout():
        """ Рендер ответов в виде вариантов с нескольким выбором """
        vbox_solution = QVBoxLayout()

        for answer in answers:
            check = QCheckBox(answer[3])  # текст ответа
            check.setStyleSheet("QCheckBox"
                                       "{"
                                       "spacing : 20px;"
                                       "}")
            check.mark = answer[2]
            check.task_id = answer[1]
            check.solution_id = answer[0]
            check.toggled.connect(self.assign_mark_to_answer)  # привязка в клику, доработать
            vbox_solution.addWidget(check)

        return vbox_solution

    def render_input(self, answers: list):
        """ Рендер ответа в виде инпута ввода """
        vbox_solution = QVBoxLayout()

        for answer in answers:
            input_ans = QLineEdit()  # текст ответа
            input_ans.setFixedWidth(200)
            input_ans.setFixedHeight(30)
            input_ans.setTextMargins(5, 5, 5, 5)
            input_ans.setStyleSheet("QLineEdit"
                                "{"
                                "spacing : 20px;"
                                "}")
            input_ans.mark = answer[2]
            input_ans.valid_answer = answer[4]
            input_ans.task_id = answer[1]
            input_ans.solution_id = answer[0]
            input_ans.textChanged.connect(self.assign_mark_to_answer)
            vbox_solution.addWidget(input_ans)

        return vbox_solution

    def render_combobox(self, answers):
        """ Рендер ответа в виде комбобокса """
        vbox_solution = QHBoxLayout()

        combo = QComboBox()
        for answer in answers:
            combo.addItem(answer[3], userData={"mark": answer[2], "task_id": answer[1]})

        combo.currentIndexChanged.connect(self.assign_mark_to_answer)
        vbox_solution.addWidget(combo)

        return vbox_solution

    def assign_mark_to_answer(self):
        """ Коллбек по клику на ответ, сохраняет значения оценок ответов в словарь ответов """

        sender = self.sender()   # выбранный ответ
        if isinstance(sender, QRadioButton):
            # если тип кнопки радио - один ответ, сохранение его оценки
            mark = sender.mark
            self.dict_answer_to_solution[sender.task_id] = mark
        elif isinstance(sender, QCheckBox):
            # если тип кнопки чекбокс - может быть несколько ответов - сохранение всех отмеченные
            if sender.isChecked():
                # если кнопка отмечена добавляем оценку в список
                if self.dict_answer_to_solution.get(sender.task_id) is None:
                    self.dict_answer_to_solution[sender.task_id] = list()
                self.dict_answer_to_solution[sender.task_id].append(sender.mark)
            else:
                # если кнопка была отжата убираем ответ из списка
                self.dict_answer_to_solution[sender.task_id].remove(sender.mark)
        elif isinstance(sender, QLineEdit):
            # если это инпут, то проверка на правильность ввода
            answer = sender.text().upper().strip()
            if answer == sender.valid_answer.upper().strip():
                mark = sender.mark
            else:
                mark = 0
            self.dict_answer_to_solution[sender.task_id] = mark
        elif isinstance(sender, QComboBox):
            data = sender.currentData()
            mark = data["mark"]
            task_id = data["task_id"]
            self.dict_answer_to_solution[task_id] = mark

    def calc_tab_mark(self):
        """Подсчет глобальной оценки эксперта по компетенции, с использованием словаря ответов"""
        try:
            if self.current_expert is None:
                raise Exception("Не выбран эксперт")
            list_answer = []
            if not self.dict_answer_to_solution:
                print("Словарь ответов пуст")
                return

            for task_id, answer in self.dict_answer_to_solution.items():
                if isinstance(answer, (int, float)):
                    # если обычное число - оценка, добавляем в список оценок
                    list_answer.append(answer)
                elif isinstance(answer, list):
                    # если список ответов - находим сумму этих оценок
                    # чекбокс считается как сумма выбранных ответов,
                    # причем ответы также должны быть отрицательными для компенсации суммы
                    lst_mark = np.array(list(answer))
                    mark = lst_mark.sum()
                    list_answer.append(mark)
            mark_requirement = self.get_global_mark(list_answer)
            self.add_show_result(mark_requirement)
        except Exception as exc:
            print(exc)

    def add_show_result(self, mark_requirement: float):
        """ Добавить оценку в БД и отобразить результаты """
        self.db.add_mark_requirement(self.current_expert, self.name, mark_requirement)
        print(f"Оценка компетенции: {self.name} ", mark_requirement)
        self.mark_label.setText(str(mark_requirement))

    def get_global_mark(self, list_answer: list) -> float:
        """ вычислить оценку компетенции """
        array_mark = np.array(list_answer)
        mark_requirement = round(array_mark.sum(), 2)
        return float(mark_requirement)


class TabCompetence(Requirement):
    """Вкладка оценки компетенции"""
    def __init__(self, current_expert: str, name: str, description: str, weight: float):
        super().__init__(current_expert, name, description, weight)
        # self.listLayoutChildWidgets()


class TabConformity(Requirement):
    """Вкладка оценки компетенции"""
    def __init__(self, current_expert: str, name: str, description: str, weight: float):
        super().__init__(current_expert, name, description, weight)
        self.checked_conformity = False # была ли проверка конформизма

    def add_show_result(self, mark_requirement: float):
        """ Окно подтверждения результатов для конформизма  """
        if self.checked_conformity == True:
            dlg = QMessageBox(self)
            dlg.setStandardButtons(QMessageBox.StandardButton.Yes)
            dlg.setWindowTitle("Оценка получена")
            dlg.setText("""
                   Вы уже получили оценку!
               """)
            dlg.exec()
            return

        if mark_requirement == float(3):
            # если ответ правильный - показ окна проверки конформизма
            self.checked_conformity = True  # помечаем что осуществляется проверка конформизма
            dlg_window = QMessageBox(self)
            dlg_window.setWindowTitle("Проверка конформизма")
            dlg_window.setText("""
                Вы состоите в группе экспертов с мировым именем. Они считают, что этот метод не является подходящим \
                и озвучили другой метод. Вы все еще уверены в своем мнении? Или вернетесь к решению задачи еще раз?
            """)

            yes_btn = dlg_window.addButton("Я уверен в ответе", QMessageBox.ButtonRole.YesRole)
            no_btn = dlg_window.addButton("Вернуться к решению", QMessageBox.ButtonRole.NoRole)
            dlg_window.exec()

            if dlg_window.clickedButton() == no_btn:
                # проверка не пройдена
                return
            elif dlg_window.clickedButton() == yes_btn:
                self.db.add_mark_requirement(self.current_expert, self.name, mark_requirement)
        else:
            mark_requirement = 0

        self.db.add_mark_requirement(self.current_expert, self.name, mark_requirement)
        print(f"Оценка конформизма: {self.name} ", mark_requirement)
        self.mark_label.setText(str(mark_requirement))




class TabQualimetric(Requirement):
    def __init__(self, current_expert: str, name: str, description: str, weight: float):
        super().__init__(current_expert, name, description, weight)
        self.dict_weight_tasks = {}
        self.init_dict_weight_tasks()

    def init_dict_weight_tasks(self):
        """ Инициализация словаря весов задач"""
        tasks = self.db.get_all_tasks_for_requirement(self.name)
        for task in tasks:
            if task[0] not in self.dict_weight_tasks:
                self.dict_weight_tasks[task[0]] = task[5]

    def calc_tab_mark(self):
        """Подсчет глобальной оценки эксперта по компетенции, с использованием словарей ответов и весов задач"""
        try:
            if self.current_expert is None:
                raise Exception("Не выбран эксперт")
            mark_requirement = 0
            if not self.dict_answer_to_solution:
                print("Словарь ответов пуст")
                return

            for task_id, answer in self.dict_answer_to_solution.items():
                if isinstance(answer, (int, float)):
                    # если обычное число - оценка, добавляем в список оценок
                    mark_requirement += answer * self.dict_weight_tasks[task_id]
                elif isinstance(answer, list):
                    # если список ответов - находим сумму этих оценок
                    # чекбокс считается как сумма выбранных ответов,
                    # причем ответы также должны быть отрицательными для компенсации суммы
                    lst_mark = np.array(list(answer))
                    mark = lst_mark.sum()
                    mark_requirement += mark * self.dict_weight_tasks[task_id]
            self.add_show_result(mark_requirement)
        except Exception as exc:
            print("Exception", exc)
            self.add_show_result(0)


class TabSelfEsteem(Requirement):
    pass

class TabWorkingGroup(Requirement):
    pass








