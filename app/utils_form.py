from PyQt6.QtWidgets import QVBoxLayout, QLabel, QLineEdit, QWidget, QPushButton
from PyQt6.QtGui import QIcon
from PyQt6.QtWidgets import QMessageBox
from PyQt6.uic import loadUi

from .db import Database


class ExpertForm(QWidget):
    def __init__(self):
        super().__init__()
        self.db = Database()
        self.setWindowTitle("Добавление пользователя")
        self.resize(300, 200)
        layout = QVBoxLayout()
        self.label = QLabel("Создание эксперта:")
        layout.addWidget(self.label)

        labelName = QLabel("Имя:")
        layout.addWidget(labelName)
        self.lineName = QLineEdit()
        layout.addWidget(self.lineName)

        labelSurname = QLabel("Фамилия:")
        layout.addWidget(labelSurname)
        self.lineSurname = QLineEdit()
        layout.addWidget(self.lineSurname)

        self.addBtn = QPushButton("Добавить")
        layout.addWidget(self.addBtn)
        self.addBtn.clicked.connect(self.add_expert)

        self.setLayout(layout)

    def add_expert(self):
        # решить вылет
        print("add ex")
        first_name = self.lineName.text()
        last_name = self.lineSurname.text()
        self.db.add_expert(first_name, last_name)
        print("end ex")
        # text = "Эксперт успешно добавлен!"
        # msg = QtWidgets.QMessageBox(text)
        # msg.show()



