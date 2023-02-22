import sys, os

from PyQt6.uic import loadUi
from PyQt6.QtWidgets import QApplication, QMainWindow, QMessageBox

from app.config import Config
from app.db import Database
from app.utils_form import ExpertForm
from app.tabs_form import Result, TabCompetence, TabConformity, TabQualimetric, TabSelfEsteem, TabWorkingGroup


class ExpertSystemMain(QMainWindow):
    def __init__(self):
        super().__init__()
        loadUi('ui/main.ui', self)
        self.setWindowTitle("Оценка компетенций экспертов")
        self.db = Database()
        self.current_expert = None

        self.comboExpert = self.comboExpert     # QComboBox чекбокс экспертов из ui
        self.expertManage = self.expertManage   # QAction пункт управления экспертами из ui
        self.expertMenu = self.expertMenu       # QTabWidget - окно табов из ui

        # типы компетенций (типы вкладок)
        self.dict_tabs = {"competence": TabCompetence,
                          "conformity": TabConformity,
                          "qualimetric": TabQualimetric,
                          "self-esteem": TabSelfEsteem,
                          "working-group": TabWorkingGroup,
                           }

        self.init_experts()
        self.init_tabs()

        self.expertManage.triggered.connect(self.show_expert_manage)

    def init_tabs(self):
        """ Инициализация всех вкладок """
        """ requirement_name, name, description, weight """
        list_tabs = self.db.get_all_requirements()

        for tab in list_tabs:
            tab_class_name = self.dict_tabs.get(tab[0]) # выбор класса вкладки
            if tab_class_name is None:
                raise Exception("Не существует класса вкладки в БД")
            tab_object = tab_class_name(self.current_expert, tab[0], tab[2], tab[3])
            self.expertMenu.addTab(tab_object, tab[1])
        result = Result()
        self.expertMenu.addTab(result, "Результаты")

    def init_experts(self):
        """ Инициализация экспертов в чекбоксе"""
        experts = self.db.get_all_experts()
        self.comboExpert.clear()
        for expert in experts:
            self.comboExpert.addItem(expert[1] + " " + expert[2], userData=expert[0])
        self.current_expert = self.comboExpert.currentData()  # данные в виде индекса эксперта
        self.comboExpert.currentIndexChanged.connect(self.change_expert)

    def change_expert(self):
        """ Смена эксперта в чекбоксе """
        self.current_expert = self.comboExpert.currentData()
        self.update_tabs()

    def update_tabs(self):
        """ Обновление вкладок при смене эксперта """
        self.expertMenu.clear()  # удаление всех вкладок
        self.init_tabs()         # рендеринг новых всех вкладок, возможно неэффективно

    def show_message(self, text: str):
        """ """
        alert_msg = QMessageBox(self)
        alert_msg.setWindowTitle("Уведомление")
        alert_msg.setText(text)
        alert_msg.exec()

    def show_expert_manage(self):
        """ Окно управления экспертами """
        self.expert_form = ExpertForm()
        self.expert_form.show()
        try:
            self.expert_form.addBtn.clicked.connect(self.init_experts)
        except Exception as exc:
            print(exc)


if __name__ == '__main__':

    if not os.path.exists(Config.name_db):
        from scripts.create_db import main
        main()

    app = QApplication([])
    application = ExpertSystemMain()
    application.show()
    sys.exit(app.exec())
