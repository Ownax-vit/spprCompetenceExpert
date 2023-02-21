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
               description varchar(512),
               weight decimal not null default 1
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

INSERT INTO requirements VALUES ("competence", "Профессиональная компетентность", "Ответьте на все вопросы:", 0.2);
INSERT INTO requirements VALUES ("conformity", "Оценка конформизма", "Пройдите оценку конформизма:", 0.15);
INSERT INTO requirements VALUES ("qualimetric", "Квалиметрическая компетентность", "Ответьте на все вопросы:", 0.15);
INSERT INTO requirements VALUES ("self-esteem", "Самооценка", "Сопоставьте компетенции с соответствующим уровнем:", 0.15);


INSERT INTO task_type VALUES ("question_variant", "Один вопрос-один ответ", "Выбор одного ответа");
INSERT INTO task_type VALUES ("check_multiple", "Чекбокс", "Выбор нескольких ответов");
INSERT INTO task_type VALUES ("question_input", "Ввод", "Ввод ответа");
INSERT INTO task_type VALUES ("question_combobox", "Комбобокс", "Выбор комбобокс");


INSERT INTO  tasks (task_id, requirement_name, task_type, name, description) VALUES (1, "competence", "question_variant", "Выберите подходы к тестированию ПО",
"Выберите подходы к тестированию ПО");
INSERT INTO solutions (task_id, mark, text, valid_answer) VALUES (1, 0.66, "Белый ящик", "");
INSERT INTO solutions (task_id, mark, text, valid_answer) VALUES ( 1, -0.66, "Позитивное тестирование", "");
INSERT INTO solutions (task_id, mark, text, valid_answer) VALUES (1, 0.66, "Серый ящик", "");
INSERT INTO solutions (task_id, mark, text, valid_answer) VALUES (1, -0.66, "Тест план", "");
INSERT INTO solutions (task_id, mark, text, valid_answer) VALUES (1, 0.66, "Черный ящик", "");

INSERT INTO  tasks (task_id, requirement_name, task_type, name, description) VALUES (2, "competence", "question_variant", "Тестирование белого ящика - это:",
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

INSERT INTO  tasks (task_id, requirement_name, task_type, name, description) VALUES (3, "competence", "question_variant", "Что такое GUI-тестирование (GUI Testing)?",
"Тестирование белого ящика - это:");
INSERT INTO solutions (task_id, mark, text, valid_answer) VALUES (3, 2, "Тестирование графического интерфейса пользователя:
 интерфейс программного обеспечения проверяется на предмет соответствия требованиям", "");
INSERT INTO solutions (task_id, mark, text, valid_answer) VALUES (3, 0, "Тестирование общей функциональности системы,
включая интеграцию данных в модулях.", "");
INSERT INTO solutions (task_id, mark, text, valid_answer) VALUES (3, 0, "Тестирование негативных сценариев в ПО:
высвечивает ли система ошибку, когда она должна это делать, или не должна.", "");

INSERT INTO  tasks (task_id, requirement_name, task_type, name, description) VALUES (4, "competence", "question_variant", "Что такое стресс-тестирование?", "");
INSERT INTO solutions (task_id, mark, text, valid_answer) VALUES (4, 0, "Анализ функциональности и производительности
приложения в разных условиях.", "");
INSERT INTO solutions (task_id, mark, text, valid_answer) VALUES (4, 2, "Проверка устойчивости системы в
 условиях превышения пределов обычного функционирования.
 Или снижение ресурсов системы и сохранение нагрузки на определенном уровне,
 чтобы проверить, как приложения при этом себя ведет.", "");
INSERT INTO solutions (task_id, mark, text, valid_answer) VALUES (4, 0, "Проверяется, насколько хорошо реализованы в
приложении все условия безопасности.", "");

INSERT INTO  tasks (task_id, requirement_name, task_type, name, description) VALUES (5, "competence", "check_multiple", "Выберите этапы жизненного цикла тестирования ПО:", "");
INSERT INTO solutions (task_id, mark, text, valid_answer) VALUES (5, 0.25, "Планирование тестов", "");
INSERT INTO solutions (task_id, mark, text, valid_answer) VALUES (5, -0.25, "Разработка", "");
INSERT INTO solutions (task_id, mark, text, valid_answer) VALUES (5, 0.25, "Создание тест-кейсов", "");
INSERT INTO solutions (task_id, mark, text, valid_answer) VALUES (5, -0.25, "Системное проектирование", "");
INSERT INTO solutions (task_id, mark, text, valid_answer) VALUES (5, 0.25, "Настройка тестового окружения", "");
INSERT INTO solutions (task_id, mark, text, valid_answer) VALUES (5, -0.25, "Внедрение ПО", "");
INSERT INTO solutions (task_id, mark, text, valid_answer) VALUES (5, 0.25, "Выполнение тестов", "");
INSERT INTO solutions (task_id, mark, text, valid_answer) VALUES (5, 0.25, "Поддержка тестов", "");

INSERT INTO  tasks (task_id, requirement_name, task_type, name, description) VALUES (6, "competence", "check_multiple", "Что такое верификация и валидация в тестировании?", "");
INSERT INTO solutions (task_id, mark, text, valid_answer) VALUES (6, 1.5, "Верификация - это техника статического анализа,
 то есть тестирование идет без выполнения кода. Например, ревью кода, его инспекция, и разбор.", "");
INSERT INTO solutions (task_id, mark, text, valid_answer) VALUES (6, -1.5, "Валидация - набор определенных шагов,
по которым проверяется функциональность системы.", "");
INSERT INTO solutions (task_id, mark, text, valid_answer) VALUES (6, -1.5, "Верификация - Это часть тест-плана,
описывающая, как проводится тестирование и какие разновидности тестирования необходимо сделать.", "");
INSERT INTO solutions (task_id, mark, text, valid_answer) VALUES (6, 1.5, "Валидация – это техника динамического анализа,
с выполнением кода приложения. При валидации могут быть как функциональные, так и нефункциональные техники тестирования.", "");

INSERT INTO  tasks (task_id, requirement_name, task_type, name, description) VALUES (7, "competence", "question_input", "Изъян в компоненте или системе, который может привести компонент или систему к невозможности выполнить требуемую функцию,
например неверный оператор или определение данных - это:", "");
INSERT INTO solutions (task_id, mark, text, valid_answer) VALUES (7, 4, "Изъян в компоненте или системе,
который может привести компонент или систему к невозможности выполнить требуемую функцию, например неверный оператор
 или определение данных - это:", "дефект");

INSERT INTO  tasks (task_id, requirement_name, task_type, name, description) VALUES (8, "competence", "question_input", "Тип тестирования программного обеспечения для подтверждения того, что недавнее изменение кода не оказало негативного влияния на существующие функции - это:", "");
INSERT INTO solutions (task_id, mark, text, valid_answer) VALUES (8, 4, "Тип тестирования программного обеспечения
для подтверждения того, что недавнее изменение кода не оказало негативного влияния
на существующие функции - это:", "регрессионное");

INSERT INTO  tasks (task_id, requirement_name, task_type, name, description) VALUES (9, "competence", "question_input", "Это ключевое слово, используемое для получения данных из нескольких таблиц на основе взаимосвязи между полями таблиц и представления результатов в виде единого набора:", "");
INSERT INTO solutions (task_id, mark, text, valid_answer) VALUES (9, 4, "Это ключевое слово, используемое для получения данных из нескольких таблиц на основе взаимосвязи между полями таблиц и
 представления результатов в виде единого набора:", "join");

INSERT INTO  tasks (task_id, requirement_name, task_type, name, description) VALUES (10, "competence", "check_multiple", "Какие бывают ограничения SQL?", "");
INSERT INTO solutions (task_id, mark, text, valid_answer) VALUES (10, 0.66, "NOT NULL", "");
INSERT INTO solutions (task_id, mark, text, valid_answer) VALUES (10, -0.66, "INTEGER", "");
INSERT INTO solutions (task_id, mark, text, valid_answer) VALUES (10, -0.66, "NULL", "");
INSERT INTO solutions (task_id, mark, text, valid_answer) VALUES (10, -0.66, "FLOAT", "");
INSERT INTO solutions (task_id, mark, text, valid_answer) VALUES (10, 0.66, "FOREIGN KEY", "");
INSERT INTO solutions (task_id, mark, text, valid_answer) VALUES (10, 0.66, "UNIQUE", "");


INSERT INTO  tasks (task_id, requirement_name, task_type, name, description) VALUES (11, "conformity", "check_multiple", "Выберите приоритет дефекта в тестировании ПО:", "");
INSERT INTO solutions (task_id, mark, text, valid_answer) VALUES (11, 0, "Блокирующий (Blocker)", "");
INSERT INTO solutions (task_id, mark, text, valid_answer) VALUES (11, 1, "Высокий (High)", "");
INSERT INTO solutions (task_id, mark, text, valid_answer) VALUES (11, 0, "Критический (Critical)", "");
INSERT INTO solutions (task_id, mark, text, valid_answer) VALUES (11, 1, "Средний (Medium) ", "");
INSERT INTO solutions (task_id, mark, text, valid_answer) VALUES (11, 0, "Значительный (Major)", "");
INSERT INTO solutions (task_id, mark, text, valid_answer) VALUES (11, 0, "Незначительный (Minor)", "");
INSERT INTO solutions (task_id, mark, text, valid_answer) VALUES (11, 0, "Тривиальный (Trivial)", "");
INSERT INTO solutions (task_id, mark, text, valid_answer) VALUES (11, 1, "Низкий (Low)", "");


INSERT INTO  tasks (task_id, requirement_name, task_type, name, description, weight) VALUES (12, "qualimetric", "question_input",
"Совокупность качеств (свойств) объектов или процессов, тождественных (сходных, однородных) по определенным признакам (база сравнения) и образующих группы - это", "", 0.1);
INSERT INTO solutions (task_id, mark, text, valid_answer) VALUES (12, 1, "совокупность качеств объектов", "join");

INSERT INTO  tasks (task_id, requirement_name, task_type, name, description, weight) VALUES (13, "qualimetric", "check_multiple",
"При помощи каких способов вы будете производить оценку и учет в моделях оценки качества различного вида неопределенностей:", "", 0.15);
INSERT INTO solutions (task_id, mark, text, valid_answer) VALUES (13, 0.5, "С помощью моделей риска", "");
INSERT INTO solutions (task_id, mark, text, valid_answer) VALUES (13, 0.5, "При помощи байесовских моделей", "");
INSERT INTO solutions (task_id, mark, text, valid_answer) VALUES (13, 0, "Регрессионный анализ", "");
INSERT INTO solutions (task_id, mark, text, valid_answer) VALUES (13, 0, "Дисперсионный анализ ", "");
INSERT INTO solutions (task_id, mark, text, valid_answer) VALUES (13, 0, "Функциональная декомпозиция", "");

INSERT INTO tasks (task_id, requirement_name, task_type, name, description, weight) VALUES (14, "qualimetric", "question_combobox", "Оцените вероятность следующих сценариев на рынке труда РФ специалистов-тестировщиков ПО. Спрос на тестировщиков увеличивается:", "", 0.25);
INSERT INTO solutions (task_id, mark, text, valid_answer) VALUES (14, 0.125, "0.7", "");
INSERT INTO solutions (task_id, mark, text, valid_answer) VALUES (14, 0, "0.5", "");
INSERT INTO solutions (task_id, mark, text, valid_answer) VALUES (14, 0, "0.3", "");

INSERT INTO tasks (task_id, requirement_name, task_type, name, description, weight) VALUES (15, "qualimetric", "question_combobox", "Спрос на тестировщиков остается стабильным", "", 0.25);
INSERT INTO solutions (task_id, mark, text, valid_answer) VALUES (15, 0, "0.7", "");
INSERT INTO solutions (task_id, mark, text, valid_answer) VALUES (15, 0.125, "0.5", "");
INSERT INTO solutions (task_id, mark, text, valid_answer) VALUES (15, 0, "0.3", "");

INSERT INTO tasks (task_id, requirement_name, task_type, name, description, weight) VALUES (16, "qualimetric", "question_combobox", "Компании приостанавливают найм новых сотрудников", "", 0.25);
INSERT INTO solutions (task_id, mark, text, valid_answer) VALUES (16, 0, "0.7", "");
INSERT INTO solutions (task_id, mark, text, valid_answer) VALUES (16, 0, "0.5", "");
INSERT INTO solutions (task_id, mark, text, valid_answer) VALUES (16, 0.125, "0.3", "");

INSERT INTO tasks (task_id, requirement_name, task_type, name, description, weight) VALUES
 (17, "qualimetric", "question_combobox", "Шкала наименования", "", 0.2);
INSERT INTO solutions (task_id, mark, text, valid_answer) VALUES (17, 0.125, "Ничего из перечисленного", "");
INSERT INTO solutions (task_id, mark, text, valid_answer) VALUES (17, 0, "Единица измерения", "");
INSERT INTO solutions (task_id, mark, text, valid_answer) VALUES (17, 0, "Нуль физической величины", "");
INSERT INTO solutions (task_id, mark, text, valid_answer) VALUES (17, 0, "Выполнение любых арифметических операций над элементами шкалы", "");

INSERT INTO tasks (task_id, requirement_name, task_type, name, description, weight) VALUES
 (18, "qualimetric", "question_combobox", "Шкала порядка", "", 0.2);
INSERT INTO solutions (task_id, mark, text, valid_answer) VALUES (18, 0, "Ничего из перечисленного", "");
INSERT INTO solutions (task_id, mark, text, valid_answer) VALUES (18, 0.125, "Единица измерения", "");
INSERT INTO solutions (task_id, mark, text, valid_answer) VALUES (18, 0, "Нуль физической величины", "");
INSERT INTO solutions (task_id, mark, text, valid_answer) VALUES (18, 0, "Выполнение любых арифметических операций над элементами шкалы", "");

INSERT INTO tasks (task_id, requirement_name, task_type, name, description, weight) VALUES
 (19, "qualimetric", "question_combobox", "Шкала интервалов", "", 0.2);
INSERT INTO solutions (task_id, mark, text, valid_answer) VALUES (19, 0, "Ничего из перечисленного", "");
INSERT INTO solutions (task_id, mark, text, valid_answer) VALUES (19, 0, "Единица измерения", "");
INSERT INTO solutions (task_id, mark, text, valid_answer) VALUES (19, 0.125, "Нуль физической величины", "");
INSERT INTO solutions (task_id, mark, text, valid_answer) VALUES (19, 0, "Выполнение любых арифметических операций над элементами шкалы", "");


INSERT INTO tasks (task_id, requirement_name, task_type, name, description, weight) VALUES
 (20, "qualimetric", "question_combobox", "Шкала отношений", "", 0.2);
INSERT INTO solutions (task_id, mark, text, valid_answer) VALUES (20, 0, "Ничего из перечисленного", "");
INSERT INTO solutions (task_id, mark, text, valid_answer) VALUES (20, 0, "Единица измерения", "");
INSERT INTO solutions (task_id, mark, text, valid_answer) VALUES (20, 0, "Нуль физической величины", "");
INSERT INTO solutions (task_id, mark, text, valid_answer) VALUES (20, 0.125, "Выполнение любых арифметических операций над элементами шкалы", "");


INSERT INTO tasks (task_id, requirement_name, task_type, name, description, weight) VALUES
 (21, "qualimetric", "question_combobox", "Шкала отношений", "", 0.2);
INSERT INTO solutions (task_id, mark, text, valid_answer) VALUES (21, 0, "Ничего из перечисленного", "");
INSERT INTO solutions (task_id, mark, text, valid_answer) VALUES (21, 0.125, "Единица измерения", "");
INSERT INTO solutions (task_id, mark, text, valid_answer) VALUES (21, 0, "Нуль физической величины", "");
INSERT INTO solutions (task_id, mark, text, valid_answer) VALUES (21, 0, "Выполнение любых арифметических операций над элементами шкалы", "");


INSERT INTO tasks (task_id, requirement_name, task_type, name, description, weight) VALUES
 (22, "qualimetric", "question_combobox", "Тестировщики играют важную роль в исправлении багов и отладкой системы", "", 0.2);
INSERT INTO solutions (task_id, mark, text, valid_answer) VALUES (22, 0.125, "0.8", "");
INSERT INTO solutions (task_id, mark, text, valid_answer) VALUES (22, 0, "0.6", "");
INSERT INTO solutions (task_id, mark, text, valid_answer) VALUES (22, 0, "0.2", "");

INSERT INTO tasks (task_id, requirement_name, task_type, name, description, weight) VALUES
 (23, "qualimetric", "question_combobox", "Разработчики занимают большую долю в команде", "", 0.2);
INSERT INTO solutions (task_id, mark, text, valid_answer) VALUES (23, 0, "0.8", "");
INSERT INTO solutions (task_id, mark, text, valid_answer) VALUES (23, 0.125, "0.6", "");
INSERT INTO solutions (task_id, mark, text, valid_answer) VALUES (23, 0, "0.2", "");

INSERT INTO tasks (task_id, requirement_name, task_type, name, description, weight) VALUES
 (24, "qualimetric", "question_combobox", "Команды больше не нуждаются в проектном управлении", "", 0.2);
INSERT INTO solutions (task_id, mark, text, valid_answer) VALUES (24, 0, "0.8", "");
INSERT INTO solutions (task_id, mark, text, valid_answer) VALUES (24, 0, "0.6", "");
INSERT INTO solutions (task_id, mark, text, valid_answer) VALUES (24, 0.125, "0.2", "");

INSERT INTO tasks (task_id, requirement_name, task_type, name, description) VALUES
 (25, "self-esteem", "question_combobox", "Опыт автотестирования", "");
INSERT INTO solutions (task_id, mark, text, valid_answer) VALUES (25, 0, "минимальный", "");
INSERT INTO solutions (task_id, mark, text, valid_answer) VALUES (25, 0.5, "средний", "");
INSERT INTO solutions (task_id, mark, text, valid_answer) VALUES (25, 1, "высокий", "");

INSERT INTO tasks (task_id, requirement_name, task_type, name, description) VALUES
 (26, "self-esteem", "question_combobox", "Опыт нагрузочного тестирования", "");
INSERT INTO solutions (task_id, mark, text, valid_answer) VALUES (26, 0, "минимальный", "");
INSERT INTO solutions (task_id, mark, text, valid_answer) VALUES (26, 0.5, "средний", "");
INSERT INTO solutions (task_id, mark, text, valid_answer) VALUES (26, 1, "высокий", "");

INSERT INTO tasks (task_id, requirement_name, task_type, name, description) VALUES
 (27, "self-esteem", "question_combobox", "Опыт работы с тест-кейсами", "");
INSERT INTO solutions (task_id, mark, text, valid_answer) VALUES (27, 0, "минимальный", "");
INSERT INTO solutions (task_id, mark, text, valid_answer) VALUES (27, 0.5, "средний", "");
INSERT INTO solutions (task_id, mark, text, valid_answer) VALUES (27, 1, "высокий", "");

INSERT INTO tasks (task_id, requirement_name, task_type, name, description) VALUES
 (28, "self-esteem", "question_combobox", "Опыт работы с описанием дефекта", "");
INSERT INTO solutions (task_id, mark, text, valid_answer) VALUES (28, 0, "минимальный", "");
INSERT INTO solutions (task_id, mark, text, valid_answer) VALUES (28, 0.5, "средний", "");
INSERT INTO solutions (task_id, mark, text, valid_answer) VALUES (28, 1, "высокий", "");

INSERT INTO tasks (task_id, requirement_name, task_type, name, description) VALUES
 (29, "self-esteem", "question_combobox", "Знание и понимание пирамиды тестирования", "");
INSERT INTO solutions (task_id, mark, text, valid_answer) VALUES (29, 0, "минимальный", "");
INSERT INTO solutions (task_id, mark, text, valid_answer) VALUES (29, 0.5, "средний", "");
INSERT INTO solutions (task_id, mark, text, valid_answer) VALUES (29, 1, "высокий", "");