import sys

from PyQt6 import QtCore, QtGui, QtWidgets
from PyQt6.QtGui import QIcon
from PyQt6.uic import loadUi

from app.db import Database
from app.utils_form import ExpertForm
from app.expert import TabCompetence



class ExpertSystem(QtWidgets.QMainWindow):
    def __init__(self):
        super().__init__()
        loadUi('ui/main.ui', self)
        self.dbTask = Database()
        self.expertManage.triggered.connect(self.show_expert_manage)
        self.tab = TabCompetence("competence", "question_answer")
        self.expertMenu.addTab(self.tab, "Оценка")

    def show_message(self, text: str):
        alertMsg = QtWidgets.QMessageBox(self)
        alertMsg.setWindowTitle("Уведомление")
        alertMsg.setText(text)
        alertMsg.exec()

    def show_expert_manage(self):
        self.expertForm = ExpertForm()
        self.expertForm.show()


if __name__ == '__main__':
    app = QtWidgets.QApplication([])
    application = ExpertSystem()
    application.show()
    sys.exit(app.exec())
