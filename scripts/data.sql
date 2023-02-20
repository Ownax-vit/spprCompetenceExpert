CREATE TRIGGER clear_mark_requirement BEFORE INSERT
ON mark_requirement
BEGIN
	DELETE FROM mark_requirement WHERE NEW.requirement_name=requirement_name AND NEW.expert_id=expert_id;
END;

INSERT INTO requirements VALUES ("competence", "Профессиональная компетентность", "Профессиональная компетентность", 0.2);
INSERT INTO requirements VALUES ("conformity", "Оценка конформизма", "Оценка конформизма", 0.15);
INSERT INTO requirements VALUES ("qualimetric", "Квалиметрическая компетентность", "Квалиметрическая компетентность", 0.15);
INSERT INTO requirements VALUES ("self-esteem", "Самооценка", "Самооценка", 0.15);


INSERT INTO task_type VALUES ("question_variant", "Один вопрос-один ответ", "Выбор одного ответа");
INSERT INTO task_type VALUES ("check_multiple", "Чекбокс", "Выбор нескольких ответов");
INSERT INTO task_type VALUES ("question_input", "Ввод", "Ввод ответа");
INSERT INTO task_type VALUES ("question_combobox", "Комбобокс", "Выбор комбобокс");


INSERT INTO  tasks VALUES (1, "competence", "question_variant", "Выберите подходы к тестированию ПО",
"Выберите подходы к тестированию ПО");
INSERT INTO solutions (task_id, mark, text, valid_answer) VALUES (1, 0.66, "Белый ящик", "");
INSERT INTO solutions (task_id, mark, text, valid_answer) VALUES ( 1, -0.66, "Позитивное тестирование", "");
INSERT INTO solutions (task_id, mark, text, valid_answer) VALUES (1, 0.66, "Серый ящик", "");
INSERT INTO solutions (task_id, mark, text, valid_answer) VALUES (1, -0.66, "Тест план", "");
INSERT INTO solutions (task_id, mark, text, valid_answer) VALUES (1, 0.66, "Черный ящик", "");

INSERT INTO  tasks VALUES (2, "competence", "question_variant", "Тестирование белого ящика - это:",
"Тестирование белого ящика - это:");
INSERT INTO solutions (task_id, mark, text, valid_answer) VALUES (2, 2, "Тестирование белого ящика проводится
это стратегия тестирования, основанная исключительно на требованиях и спецификациях.  Это тестирование не имеет доступа к
 исходному коду и тестирует только входы и выходы программы, не затрагивая внутреннее устройство", "");
INSERT INTO solutions (task_id, mark, text, valid_answer) VALUES (2, 0, "Тестирование белого ящика
(также известное как тестирование юнита) проводится на уровне исходного кода. Оно проверяет,
что каждая функция или модуль программы работает так, как задумывалось, и выполняет свои ожидаемые операции.", "");
INSERT INTO solutions (task_id, mark, text, valid_answer) VALUES (2, 0, "Тестирование белого ящика является комбинацией
 тестирования белого и черного ящика. Это тестирование дает доступ к некоторым внутренним частям программы,
 таким как данные или переменные, но не имеет полного доступа к исходному коду. Целью тестирования белого
 ящика является проверка того,
 как программа обрабатывает данные и взаимодействует с другими частями программы
", "");

INSERT INTO  tasks VALUES (3, "competence", "question_variant", "Что такое GUI-тестирование (GUI Testing)?",
"Тестирование белого ящика - это:");
INSERT INTO solutions (task_id, mark, text, valid_answer) VALUES (3, 2, "Тестирование графического интерфейса пользователя:
 интерфейс программного обеспечения проверяется на предмет соответствия требованиям", "");
INSERT INTO solutions (task_id, mark, text, valid_answer) VALUES (3, 0, "Тестирование общей функциональности системы,
включая интеграцию данных в модулях.", "");
INSERT INTO solutions (task_id, mark, text, valid_answer) VALUES (3, 0, "Тестирование негативных сценариев в ПО:
высвечивает ли система ошибку, когда она должна это делать, или не должна.", "");

INSERT INTO  tasks VALUES (4, "competence", "question_variant", "Что такое стресс-тестирование?", "");
INSERT INTO solutions (task_id, mark, text, valid_answer) VALUES (4, 0, "Анализ функциональности и производительности
приложения в разных условиях.", "");
INSERT INTO solutions (task_id, mark, text, valid_answer) VALUES (4, 2, "Проверка устойчивости системы в
 условиях превышения пределов обычного функционирования.
 Или снижение ресурсов системы и сохранение нагрузки на определенном уровне,
 чтобы проверить, как приложения при этом себя ведет.", "");
INSERT INTO solutions (task_id, mark, text, valid_answer) VALUES (4, 0, "Проверяется, насколько хорошо реализованы в
приложении все условия безопасности.", "");

INSERT INTO  tasks VALUES (5, "competence", "check_multiple", "Выберите этапы жизненного цикла тестирования ПО:", "");
INSERT INTO solutions (task_id, mark, text, valid_answer) VALUES (5, 0.25, "Планирование тестов", "");
INSERT INTO solutions (task_id, mark, text, valid_answer) VALUES (5, -0.25, "Разработка", "");
INSERT INTO solutions (task_id, mark, text, valid_answer) VALUES (5, 0.25, "Создание тест-кейсов", "");
INSERT INTO solutions (task_id, mark, text, valid_answer) VALUES (5, -0.25, "Системное проектирование", "");
INSERT INTO solutions (task_id, mark, text, valid_answer) VALUES (5, 0.25, "Настройка тестового окружения", "");
INSERT INTO solutions (task_id, mark, text, valid_answer) VALUES (5, -0.25, "Внедрение ПО", "");
INSERT INTO solutions (task_id, mark, text, valid_answer) VALUES (5, 0.25, "Выполнение тестов", "");
INSERT INTO solutions (task_id, mark, text, valid_answer) VALUES (5, 0.25, "Поддержка тестов", "");

INSERT INTO  tasks VALUES (6, "competence", "check_multiple", "Что такое верификация и валидация в тестировании?", "");
INSERT INTO solutions (task_id, mark, text, valid_answer) VALUES (6, 1.5, "Верификация - это техника статического анализа,
 то есть тестирование идет без выполнения кода. Например, ревью кода, его инспекция, и разбор.", "");
INSERT INTO solutions (task_id, mark, text, valid_answer) VALUES (6, -1.5, "Валидация - набор определенных шагов,
по которым проверяется функциональность системы.", "");
INSERT INTO solutions (task_id, mark, text, valid_answer) VALUES (6, -1.5, "Верификация - Это часть тест-плана,
описывающая, как проводится тестирование и какие разновидности тестирования необходимо сделать.", "");
INSERT INTO solutions (task_id, mark, text, valid_answer) VALUES (6, 1.5, "Валидация – это техника динамического анализа,
с выполнением кода приложения. При валидации могут быть как функциональные, так и нефункциональные техники тестирования.", "");

INSERT INTO  tasks VALUES (7, "competence", "question_input", "Изъян в компоненте или системе,
который может привести компонент или систему к невозможности выполнить требуемую функцию,
например неверный оператор или определение данных - это:", "");
INSERT INTO solutions (task_id, mark, text, valid_answer) VALUES (7, 4, "Изъян в компоненте или системе,
который может привести компонент или систему к невозможности выполнить требуемую функцию, например неверный оператор
 или определение данных - это:", "дефект");

INSERT INTO  tasks VALUES (8, "competence", "question_input", "Тип тестирования программного обеспечения для
подтверждения того, что недавнее изменение кода не оказало негативного влияния
на существующие функции - это:", "");
INSERT INTO solutions (task_id, mark, text, valid_answer) VALUES (8, 4, "Тип тестирования программного обеспечения
для подтверждения того, что недавнее изменение кода не оказало негативного влияния
на существующие функции - это:", "регрессионное");

INSERT INTO  tasks VALUES (9, "competence", "question_input", "Это ключевое слово,
 используемое для получения данных из нескольких таблиц на основе взаимосвязи между полями таблиц и
 представления результатов в виде единого набора:", "");
INSERT INTO solutions (task_id, mark, text, valid_answer) VALUES (9, 4, "Это ключевое слово, используемое для
получения данных из нескольких таблиц на основе взаимосвязи между полями таблиц и
 представления результатов в виде единого набора:", "join");

INSERT INTO  tasks VALUES (10, "competence", "check_multiple", "Какие бывают ограничения SQL?", "");
INSERT INTO solutions (task_id, mark, text, valid_answer) VALUES (10, 0.66, "NOT NULL", "");
INSERT INTO solutions (task_id, mark, text, valid_answer) VALUES (10, -0.66, "INTEGER", "");
INSERT INTO solutions (task_id, mark, text, valid_answer) VALUES (10, -0.66, "NULL", "");
INSERT INTO solutions (task_id, mark, text, valid_answer) VALUES (10, -0.66, "FLOAT", "");
INSERT INTO solutions (task_id, mark, text, valid_answer) VALUES (10, 0.66, "FOREIGN KEY", "");
INSERT INTO solutions (task_id, mark, text, valid_answer) VALUES (10, 0.66, "UNIQUE", "");


INSERT INTO  tasks VALUES (11, "conformity", "check_multiple", "Выберите приоритет дефекта в тестировании ПО:", "");
INSERT INTO solutions (task_id, mark, text, valid_answer) VALUES (11, 0.66, "Блокирующий (Blocker)", "");
INSERT INTO solutions (task_id, mark, text, valid_answer) VALUES (11, 0.66, "Высокий (High)", "");
INSERT INTO solutions (task_id, mark, text, valid_answer) VALUES (11, 0.66, "Критический (Critical)", "");
INSERT INTO solutions (task_id, mark, text, valid_answer) VALUES (11, 0.66, "Средний (Medium) ", "");
INSERT INTO solutions (task_id, mark, text, valid_answer) VALUES (11, 0.66, "Значительный (Major)", "");
INSERT INTO solutions (task_id, mark, text, valid_answer) VALUES (11, 0.66, "Незначительный (Minor)", "");
INSERT INTO solutions (task_id, mark, text, valid_answer) VALUES (11, 0.66, "Тривиальный (Trivial)", "");
INSERT INTO solutions (task_id, mark, text, valid_answer) VALUES (11, 0.66, "Низкий (Low)", "");