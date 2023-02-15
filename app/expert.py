from PyQt6 import QtCore, QtGui, QtWidgets
from PyQt6.QtGui import QIcon
from PyQt6.uic import loadUi

from .db import Database



# ? наследование от таба ??
class Requirement(QtWidgets.QWidget):
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
        self.show()

    def render(self):
        """ Рендер всей вкладки, всех задач"""
        all_tasks = self.db.get_all_tasks_for_requirement(self.name)
        layout_widget_main = QtWidgets.QLayout()
        for task in all_tasks:
            layoutBox = QtWidgets.QFormLayout()
            taskBlock = self.render_task(task)
            layoutBox.addWidget(taskBlock)
        layout_widget_main.addWidget(layoutBox)
        self.setLayout(layout_widget_main)

    def render_task(self, task: list) -> QtWidgets.QGroupBox:
        """Рендер задачи c ответами"""
        """task_id, requirement_name, type_task_id, name, description"""
        groupBox = QtWidgets.QGroupBox(task[4])

        radio1 = QtWidgets.QRadioButton("&Radio button 1")
        radio1.mark = 0.2

        radio2 = QtWidgets.QRadioButton("R&adio button 2")
        radio2.mark = 0.4

        radio3 = QtWidgets.QRadioButton("Ra&dio button 3")
        radio3.mark = 0.0

        vbox = QtWidgets.QVBoxLayout()
        vbox.addWidget(radio1)
        vbox.addWidget(radio2)
        vbox.addWidget(radio3)

        groupBox.setLayout(vbox)
        return groupBox


