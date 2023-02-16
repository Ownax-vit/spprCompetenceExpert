import random

import numpy as np
from PyQt6 import QtCore, QtGui
from PyQt6.QtWidgets import QWidget, QScrollArea, QBoxLayout, \
    QVBoxLayout, QRadioButton, QGroupBox, QLabel, QPushButton, QCheckBox, QComboBox, \
    QTableWidget, QTableWidgetItem
from PyQt6.QtCore import Qt
from PyQt6.QtGui import QIcon
from PyQt6.uic import loadUi

from .db import Database
from .utils import transform_mark_requirement_to_dict


class Result(QWidget):
    """
        Класс вкладки результатов, отображет
        таблицу результатов всех экспертов, выводит график
    """

    def __init__(self):
        super().__init__()
        self.db = Database()
        # self.dict_marks_requirement = transform_mark_requirement_to_dict(self.db.get_all_marks_requirements_experts())
        # self.render()

    def render(self):
        """ Рендер вкладки результатов """
        table = QTableWidget(self)
        print(self.dict_marks_requirement)

        table.setRowCount(len(self.dict_marks_requirement.keys()))
        table.setRowCount(len(self.dict_marks_requirement.keys()))


class Requirement(QWidget):
    """ Конкретная оценка компетенции к эксперту, представляет собой вкладку в окне"""
    def __init__(self, current_expert: str, name: str, description: str, weight: float):
        super().__init__()

        self.db = Database()
        self.current_expert = current_expert  # текущий оцениваемый эксперт
        self.name = name                      # наименование вкладки из БД
        self.description = description        # описание вкладки из БД
        self.weight = weight                  # глобальный вес компетенции

        # словарь типов задач
        self.dict_types_tasks = {"question-variant": self.render_variant,
                           "check_multiple": self.render_check_multiple,
                           # "question_checkbox": self.render_checkbox,
                           # "question_input": self.render_input
                           }
        self.dict_answer_to_solution = {}


    def render(self):
        """ Рендер всей вкладки - все задачи, все ответы для задач """
        all_tasks = self.db.get_all_tasks_for_requirement(self.name)
        scroll_area = QScrollArea()  # скролл
        widget_tab = QWidget()
        self.vbox = QVBoxLayout()
        vbox_main = QVBoxLayout()

        for task in all_tasks:
            task_box = self.render_task(task)
            self.vbox.addWidget(task_box)

        btn_send = QPushButton("Отправить")     # кнопка подсчета оценки компетенции
        btn_send.clicked.connect(self.calc_tab_mark)
        self.vbox.addWidget(btn_send)

        widget_tab.setLayout(self.vbox)
        scroll_area.setWidgetResizable(True)
        scroll_area.setWidget(widget_tab)
        vbox_main.addWidget(scroll_area)
        self.setLayout(vbox_main)

    def render_task(self, task: list) -> QGroupBox:
        """Рендер задачи c ответами"""
        """ task_id, requirement_name, task_type, name, description """

        groupBox = QGroupBox(task[4])
        answers = self.db.get_all_solution_for_task(task[0])

        type_task = self.dict_types_tasks.get(task[2]) # получение метода рендеринга в зависимости от типа задачи
        if type_task is None:
            raise Exception("Не существует задачи в БД")
        vbox_answers = type_task(answers)       # рендеринг по соответствующему методу

        groupBox.setLayout(vbox_answers)
        return groupBox

    def render_variant(self, answers: list) -> QVBoxLayout():
        """ Рендер ответов в виде обычного выбора варианта """
        vbox_solution = QVBoxLayout()

        for answer in answers:
            radio = QRadioButton(answer[3])     # Кнопка ответа с соответствующим текстом
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
            check.mark = answer[2]
            check.task_id = answer[1]
            check.solution_id = answer[0]
            check.toggled.connect(self.assign_mark_to_answer)  # привязка в клику, доработать
            vbox_solution.addWidget(check)

        return vbox_solution

    def assign_mark_to_answer(self):
        """ Коллбек по клику на ответ, сохраняет значения оценок ответов в словарь ответов """

        sender = self.sender()   # выбранный ответ
        if isinstance(sender, (QRadioButton, QComboBox)):
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

    def load_answers_from_db(self):
        """ Вывести ответы во вкладки из БД """
        raise NotImplementedError

    def calc_tab_mark(self):
        """Подсчет глобальной оценки эксперта по компетенции, с использованием словаря ответов"""
        """ У каждой компетенции своя формула?"""
        raise NotImplementedError

    def save_mark_requirement(self, mark: float):
        """Добавление оценки компетенции в бд"""
        pass


class TabCompetence(Requirement):
    """Вкладка оценки компетенции"""
    def __init__(self, current_expert: str, name: str, description: str, weight: float):
        super().__init__(current_expert, name, description, weight)
        self.render()
        # self.listLayoutChildWidgets()

    def calc_tab_mark(self):
        """Подсчет глобальной оценки эксперта по компетенции, с использованием словаря ответов"""
        """Почему метод родительский? Возможно применение разных формул для подсчета компетенций """
        # добавить проверку ответа всех вопросов
        # для примера пусть это будет среднее всех ответов
        try:
            list_answer = []
            if not self.dict_answer_to_solution:
                print("Словарь ответов пуст")
                return

            for solution, answer in self.dict_answer_to_solution.items():
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
            array_mark = np.array(list_answer)
            mark_requirement = round(array_mark.mean(), 2)
            self.db.add_mark_requirement(self.current_expert, self.name, mark_requirement)
        except Exception as exc:
            print(exc)
        print(f"Оценка компетенции: {self.name} ", mark_requirement)


class TabConformity(Requirement):
    """Вкладка оценки компетенции"""
    def __init__(self, current_expert: str, name: str, description: str, weight: float):
        super().__init__(current_expert, name, description, weight)
        self.render()
        # self.listLayoutChildWidgets()

    def calc_tab_mark(self):
        """Подсчет глобальной оценки эксперта по компетенции, с использованием словаря ответов"""
        """Почему метод родительский? Возможно применение разных формул для подсчета компетенций """
        # добавить проверку ответа всех вопросов
        # для примера пусть это будет среднее всех ответов
        try:
            list_answer = []
            if not self.dict_answer_to_solution:
                print("Словарь ответов пуст")
                return

            for solution, answer in self.dict_answer_to_solution.items():
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
            array_mark = np.array(list_answer)
            mark_requirement = round(array_mark.mean(), 2)
            self.db.add_mark_requirement(self.current_expert, self.name, mark_requirement)
            print(f"Оценка конформизма: {self.name} ", mark_requirement)
        except Exception as exc:
            print(exc)










