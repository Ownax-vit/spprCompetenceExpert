from PyQt6 import QtCore, QtGui
from PyQt6.QtWidgets import QWidget, QScrollArea, QBoxLayout, \
    QVBoxLayout, QRadioButton, QGroupBox, QLabel, QPushButton
from PyQt6.QtCore import Qt
from PyQt6.QtGui import QIcon
from PyQt6.uic import loadUi

from .db import Database



# ? наследование от таба ??
class Requirement(QWidget):
    def __init__(self, name: str, type: str):
        super().__init__()
        # принять конкретную вкладку, дальше рендеринг, логика здесь и ниже по иерархии
        self.db = Database()
        self.name = name
        self.type = type

    def render(self):
        pass

    def save_answers(self):
        pass

    def reset(self):
        pass


class TabCompetence(Requirement):
    def __init__(self, name: str, type: str):
        super().__init__(name, type)
        self.render()

    def render(self):
        """ Рендер всей вкладки, всех задач"""
        all_tasks = self.db.get_all_tasks_for_requirement(self.name)

        scrollArea = QScrollArea() # скролл, принимает только виджет
        widgetTab = QWidget()
        vbox = QVBoxLayout()
        vboxMain = QVBoxLayout()

        for i in range(20):
            for i in all_tasks:
                lbl = self.render_task(i)
                vbox.addWidget(lbl)
        btnSend = QPushButton("Отправить")
        vbox.addWidget(btnSend)

        widgetTab.setLayout(vbox)
        scrollArea.setWidgetResizable(True)
        scrollArea.setWidget(widgetTab)
        vboxMain.addWidget(scrollArea)
        self.setLayout(vboxMain)


    def render_task(self, task: list) -> QGroupBox:
        """Рендер задачи c ответами"""
        """task_id, requirement_name, type_task_id, name, description"""
        groupBox = QGroupBox(task[4])
        answers = self.db.get_all_answers_for_task(task[0])
        vbox = QVBoxLayout()

        for answer in answers:
            radio = QRadioButton(answer[3])
            print(answer[2])
            radio.clicked.connect(lambda: print(float(answer[2])))
            vbox.addWidget(radio)

        groupBox.setLayout(vbox)
        return groupBox



