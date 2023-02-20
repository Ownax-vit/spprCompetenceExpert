       create table experts(
            expert_id integer not null primary key autoincrement,
            first_name varchar(255) not null,
            last_name varchar(255) not null
        );
           create table requirements(
               requirement_name varchar(255) not null primary key,
               name varchar(255) not null,
               description varchar(255) not null,
               weight decimal not null
           );
           create table task_type(
               task_type varchar(255) not null primary key,
               name varchar(255) not null,
               description varchar(512)
           );
           create table tasks(
               task_id integer not null primary key autoincrement,
               requirement_name varchar(255) references requirements ON DELETE CASCADE ON UPDATE CASCADE,
               task_type varchar(255) references task_type ON DELETE CASCADE ON UPDATE CASCADE,
               name varchar(255) not null,
               description varchar(512)
           );
         create table solutions(
             solution_id integer not null primary key autoincrement,
             task_id integer references tasks ON DELETE CASCADE ON UPDATE CASCADE,
             mark decimal not null,
             text varchar(255),
             valid_answer varchar(255) default null
         );
         create table answers(
             answer_id integer not null primary key autoincrement,
             expert_id integer references experts ON DELETE CASCADE ON UPDATE CASCADE,
             solution_id integer references answers ON DELETE CASCADE ON UPDATE CASCADE
         );
         create table mark_requirement(
             mark_requirement_id integer not null primary key autoincrement,
             expert_id integer references experts ON DELETE CASCADE ON UPDATE CASCADE,
             requirement_name varchar(255) references requirements ON DELETE CASCADE ON UPDATE CASCADE,
             mark decimal not null

         );
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


INSERT INTO  tasks VALUES (12, "qualimetric", "question_combobox",
"Сопоставьте категории метрик для проведения тестирования с их примерами. Качество тест-дизайна:", "");
INSERT INTO solutions (task_id, mark, text, valid_answer) VALUES (12, 0.2, "Средняя экспертная оценка тестов", "");
INSERT INTO solutions (task_id, mark, text, valid_answer) VALUES (12, 0, "Средняя оценка пользователей", "");
INSERT INTO solutions (task_id, mark, text, valid_answer) VALUES (12, 0, "Производительность в динамике", "");
INSERT INTO solutions (task_id, mark, text, valid_answer) VALUES (12, 0, "Ложные прохождения тестов", "");
INSERT INTO solutions (task_id, mark, text, valid_answer) VALUES (12, 0, "Проведение тестов на поддерживаемых окружениях", "");

INSERT INTO  tasks VALUES (13, "qualimetric", "question_combobox","Качество продукта:", "");
INSERT INTO solutions (task_id, mark, text, valid_answer) VALUES (13, 0, "Средняя экспертная оценка тестов", "");
INSERT INTO solutions (task_id, mark, text, valid_answer) VALUES (13, 0.2, "Средняя оценка пользователей", "");
INSERT INTO solutions (task_id, mark, text, valid_answer) VALUES (13, 0, "Производительность в динамике", "");
INSERT INTO solutions (task_id, mark, text, valid_answer) VALUES (13, 0, "Ложные прохождения тестов", "");
INSERT INTO solutions (task_id, mark, text, valid_answer) VALUES (13, 0, "Проведение тестов на поддерживаемых окружениях", "");

INSERT INTO  tasks VALUES (14, "qualimetric", "question_combobox","Характеристики качества ПО:", "");
INSERT INTO solutions (task_id, mark, text, valid_answer) VALUES (14, 0, "Средняя экспертная оценка тестов", "");
INSERT INTO solutions (task_id, mark, text, valid_answer) VALUES (14, 0, "Средняя оценка пользователей", "");
INSERT INTO solutions (task_id, mark, text, valid_answer) VALUES (14, 0.2, "Производительность в динамике", "");
INSERT INTO solutions (task_id, mark, text, valid_answer) VALUES (14, 0, "Ложные прохождения тестов", "");
INSERT INTO solutions (task_id, mark, text, valid_answer) VALUES (14, 0, "Проведение тестов на поддерживаемых окружениях", "");

INSERT INTO  tasks VALUES (15, "qualimetric", "question_combobox", "Автоматизированное тестирование:", "");
INSERT INTO solutions (task_id, mark, text, valid_answer) VALUES (15, 0, "Средняя экспертная оценка тестов", "");
INSERT INTO solutions (task_id, mark, text, valid_answer) VALUES (15, 0, "Средняя оценка пользователей", "");
INSERT INTO solutions (task_id, mark, text, valid_answer) VALUES (15, 0, "Производительность в динамике", "");
INSERT INTO solutions (task_id, mark, text, valid_answer) VALUES (15, 0.2, "Ложные прохождения тестов", "");
INSERT INTO solutions (task_id, mark, text, valid_answer) VALUES (15, 0, "Проведение тестов на поддерживаемых окружениях", "");

INSERT INTO  tasks VALUES (16, "qualimetric", "question_combobox", "Тестовое покрытие:", "");
INSERT INTO solutions (task_id, mark, text, valid_answer) VALUES (16, 0, "Средняя экспертная оценка тестов", "");
INSERT INTO solutions (task_id, mark, text, valid_answer) VALUES (16, 0, "Средняя оценка пользователей", "");
INSERT INTO solutions (task_id, mark, text, valid_answer) VALUES (16, 0, "Производительность в динамике", "");
INSERT INTO solutions (task_id, mark, text, valid_answer) VALUES (16, 0, "Ложные прохождения тестов", "");
INSERT INTO solutions (task_id, mark, text, valid_answer) VALUES (16, 0.2, "Проведение тестов на поддерживаемых окружениях", "");

INSERT INTO  tasks VALUES (17, "qualimetric", "question_combobox", "Присвойте каждому этапу тестирования их порядковый номер. Создание плана:", "");
INSERT INTO solutions (task_id, mark, text, valid_answer) VALUES (17, 0.125, "2", "");
INSERT INTO solutions (task_id, mark, text, valid_answer) VALUES (17, 0, "5", "");
INSERT INTO solutions (task_id, mark, text, valid_answer) VALUES (17, 0, "7", "");
INSERT INTO solutions (task_id, mark, text, valid_answer) VALUES (17, 0, "4", "");
INSERT INTO solutions (task_id, mark, text, valid_answer) VALUES (17, 0, "8", "");
INSERT INTO solutions (task_id, mark, text, valid_answer) VALUES (17, 0, "3", "");
INSERT INTO solutions (task_id, mark, text, valid_answer) VALUES (17, 0, "1", "");
INSERT INTO solutions (task_id, mark, text, valid_answer) VALUES (17, 0, "6", "");

INSERT INTO  tasks VALUES (18, "qualimetric", "question_combobox", "Тестирование билда:", "");
INSERT INTO solutions (task_id, mark, text, valid_answer) VALUES (18, 0, "2", "");
INSERT INTO solutions (task_id, mark, text, valid_answer) VALUES (18, 0.125, "5", "");
INSERT INTO solutions (task_id, mark, text, valid_answer) VALUES (18, 0, "7", "");
INSERT INTO solutions (task_id, mark, text, valid_answer) VALUES (18, 0, "4", "");
INSERT INTO solutions (task_id, mark, text, valid_answer) VALUES (18, 0, "8", "");
INSERT INTO solutions (task_id, mark, text, valid_answer) VALUES (18, 0, "3", "");
INSERT INTO solutions (task_id, mark, text, valid_answer) VALUES (18, 0, "1", "");
INSERT INTO solutions (task_id, mark, text, valid_answer) VALUES (18, 0, "6", "");

INSERT INTO  tasks VALUES (19, "qualimetric", "question_combobox", "Приемочное тестирование:", "");
INSERT INTO solutions (task_id, mark, text, valid_answer) VALUES (19, 0, "2", "");
INSERT INTO solutions (task_id, mark, text, valid_answer) VALUES (19, 0, "5", "");
INSERT INTO solutions (task_id, mark, text, valid_answer) VALUES (19, 0.125, "7", "");
INSERT INTO solutions (task_id, mark, text, valid_answer) VALUES (19, 0, "4", "");
INSERT INTO solutions (task_id, mark, text, valid_answer) VALUES (19, 0, "8", "");
INSERT INTO solutions (task_id, mark, text, valid_answer) VALUES (19, 0, "3", "");
INSERT INTO solutions (task_id, mark, text, valid_answer) VALUES (19, 0, "1", "");
INSERT INTO solutions (task_id, mark, text, valid_answer) VALUES (19, 0, "6", "");

INSERT INTO  tasks VALUES (20, "qualimetric", "question_combobox", "Тест дизайн:", "");
INSERT INTO solutions (task_id, mark, text, valid_answer) VALUES (20, 0, "2", "");
INSERT INTO solutions (task_id, mark, text, valid_answer) VALUES (20, 0, "5", "");
INSERT INTO solutions (task_id, mark, text, valid_answer) VALUES (20, 0, "7", "");
INSERT INTO solutions (task_id, mark, text, valid_answer) VALUES (20, 0.125, "4", "");
INSERT INTO solutions (task_id, mark, text, valid_answer) VALUES (20, 0, "8", "");
INSERT INTO solutions (task_id, mark, text, valid_answer) VALUES (20, 0, "3", "");
INSERT INTO solutions (task_id, mark, text, valid_answer) VALUES (20, 0, "1", "");
INSERT INTO solutions (task_id, mark, text, valid_answer) VALUES (20, 0, "6", "");

INSERT INTO  tasks VALUES (21, "qualimetric", "question_combobox", "Репорты и результаты:", "");
INSERT INTO solutions (task_id, mark, text, valid_answer) VALUES (21, 0, "2", "");
INSERT INTO solutions (task_id, mark, text, valid_answer) VALUES (21, 0, "5", "");
INSERT INTO solutions (task_id, mark, text, valid_answer) VALUES (21, 0, "7", "");
INSERT INTO solutions (task_id, mark, text, valid_answer) VALUES (21, 0, "4", "");
INSERT INTO solutions (task_id, mark, text, valid_answer) VALUES (21, 0.125, "8", "");
INSERT INTO solutions (task_id, mark, text, valid_answer) VALUES (21, 0, "3", "");
INSERT INTO solutions (task_id, mark, text, valid_answer) VALUES (21, 0, "1", "");
INSERT INTO solutions (task_id, mark, text, valid_answer) VALUES (21, 0, "6", "");

INSERT INTO  tasks VALUES (22, "qualimetric", "question_combobox", "Сбор требований:", "");
INSERT INTO solutions (task_id, mark, text, valid_answer) VALUES (22, 0, "2", "");
INSERT INTO solutions (task_id, mark, text, valid_answer) VALUES (22, 0, "5", "");
INSERT INTO solutions (task_id, mark, text, valid_answer) VALUES (22, 0, "7", "");
INSERT INTO solutions (task_id, mark, text, valid_answer) VALUES (22, 0, "4", "");
INSERT INTO solutions (task_id, mark, text, valid_answer) VALUES (22, 0, "8", "");
INSERT INTO solutions (task_id, mark, text, valid_answer) VALUES (22, 0.125, "3", "");
INSERT INTO solutions (task_id, mark, text, valid_answer) VALUES (22, 0, "1", "");
INSERT INTO solutions (task_id, mark, text, valid_answer) VALUES (22, 0, "6", "");

INSERT INTO  tasks VALUES (23, "qualimetric", "question_combobox", "Оценка проекта:", "");
INSERT INTO solutions (task_id, mark, text, valid_answer) VALUES (23, 0, "2", "");
INSERT INTO solutions (task_id, mark, text, valid_answer) VALUES (23, 0, "5", "");
INSERT INTO solutions (task_id, mark, text, valid_answer) VALUES (23, 0, "7", "");
INSERT INTO solutions (task_id, mark, text, valid_answer) VALUES (23, 0, "4", "");
INSERT INTO solutions (task_id, mark, text, valid_answer) VALUES (23, 0, "8", "");
INSERT INTO solutions (task_id, mark, text, valid_answer) VALUES (23, 0, "3", "");
INSERT INTO solutions (task_id, mark, text, valid_answer) VALUES (23, 0.125, "1", "");
INSERT INTO solutions (task_id, mark, text, valid_answer) VALUES (23, 0, "6", "");

INSERT INTO  tasks VALUES (24, "qualimetric", "question_combobox", "Выполнение тестов:", "");
INSERT INTO solutions (task_id, mark, text, valid_answer) VALUES (24, 0, "2", "");
INSERT INTO solutions (task_id, mark, text, valid_answer) VALUES (24, 0, "5", "");
INSERT INTO solutions (task_id, mark, text, valid_answer) VALUES (24, 0, "7", "");
INSERT INTO solutions (task_id, mark, text, valid_answer) VALUES (24, 0, "4", "");
INSERT INTO solutions (task_id, mark, text, valid_answer) VALUES (24, 0, "8", "");
INSERT INTO solutions (task_id, mark, text, valid_answer) VALUES (24, 0, "3", "");
INSERT INTO solutions (task_id, mark, text, valid_answer) VALUES (24, 0, "1", "");
INSERT INTO solutions (task_id, mark, text, valid_answer) VALUES (24, 0.125, "6", "");