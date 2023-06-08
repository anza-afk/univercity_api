INSERT INTO public.building (title, building_number)
VALUES
    ('Корпус 1', 1),
    ('Корпус 2', 2),
    ('Корпус 3', 3)
ON CONFLICT (title) DO UPDATE SET title=building.title;

INSERT INTO public.teacher ("name", surname, last_name)
SELECT *
FROM (
VALUES
    ('Виталий', 'Андреевич', 'Шутко'),
    ('Василий', 'Григорьевич', 'Иванов'),
    ('Александр', 'Петрович', 'Жёлтый')
) AS values_inserted("name", surname, last_name)
WHERE NOT EXISTS (SELECT * FROM public.teacher 
    WHERE teacher."name"=values_inserted."name" 
    AND teacher.surname=values_inserted.surname
    AND teacher.last_name=values_inserted.last_name);

INSERT INTO public.auditorium ("number", building_id)
SELECT *
FROM (VALUES
    (110, (SELECT id from building WHERE title='Корпус 1')),
    (213, (SELECT id from building WHERE title='Корпус 2')),
    (113, (SELECT id from building WHERE title='Корпус 3')),
    (364, (SELECT id from building WHERE title='Корпус 2')),
    (202, (SELECT id from building WHERE title='Корпус 2'))
) AS values_inserted("number", building_id)
WHERE NOT EXISTS (SELECT * FROM public.auditorium 
    WHERE auditorium."number"=values_inserted."number" 
    AND auditorium.building_id=values_inserted.building_id);

INSERT INTO public.faculty (title, building_id, "description")
VALUES
    ('Факультет права',
    (SELECT id from building WHERE title='Корпус 1'),
    'За четверть века факультет сумел стать одним из ведущих центров юридического образования и науки не только в России, но и за рубежом. Это стало возможным благодаря совмещению фундаментального подхода к преподаванию правовых дисциплин и передовых образовательных практик'),
    ('Факультет высшей экономики и менеджмента',
    (SELECT id from building WHERE title='Корпус 2'),
    'Признанный центр подготовки экономистов и управленцев, действующий в интересах социально-экономического развития'),
    ('Факультет столярного дела',
    (SELECT id from building WHERE title='Корпус 3'),
    'Программы обучения согласованы с профессиональными стандартами, разработанными Ассоциацией предприятий мебельной и деревообрабатывающей промышленности')
ON CONFLICT (title) DO UPDATE SET title=faculty.title;

INSERT INTO public.syllabus (title, faculty_id)
VALUES
    ('Учебный план направления менеджмент',
    (SELECT id from faculty WHERE title='Факультет высшей экономики и менеджмента')),
    ('Учебный план направления высшая экономика',
    (SELECT id from faculty WHERE title='Факультет высшей экономики и менеджмента')),
    ('Учебный план столярного дела',
    (SELECT id from faculty WHERE title='Факультет столярного дела')),
    ('Учебный план права',
    (SELECT id from faculty WHERE title='Факультет права'))
ON CONFLICT (title) DO UPDATE SET title=syllabus.title;

INSERT INTO public.semester (title, syllabus_id)
SELECT *
FROM (VALUES
    ('Первый семестр право',
    (SELECT id from syllabus WHERE title='Учебный план права')),
    ('Ворой семестр право',
    (SELECT id from syllabus WHERE title='Учебный план права')),
    ('Первый семестр экономика',
    (SELECT id from syllabus WHERE title='Учебный план направления высшая экономика')),
    ('Первый семестр менеджмент',
    (SELECT id from syllabus WHERE title='Учебный план направления менеджмент')),
    ('Ворой семестр столярное дело',
    (SELECT id from syllabus WHERE title='Учебный план столярного дела'))
) AS values_inserted(title, syllabus_id)
WHERE NOT EXISTS (SELECT * FROM public.semester 
    WHERE semester.title=values_inserted.title 
    AND semester.syllabus_id=values_inserted.syllabus_id);

INSERT INTO public.course (title, semester_id)
VALUES
    ('Теория государства и права',
    (SELECT id from semester WHERE title='Первый семестр право')),
    ('История государства и права России',
    (SELECT id from semester WHERE title='Ворой семестр право')),
    ('Математика',
    (SELECT id from semester WHERE title='Первый семестр экономика')),
    ('Бухгалтерия',
    (SELECT id from semester WHERE title='Первый семестр экономика')),
    ('Мат анализ',
    (SELECT id from semester WHERE title='Первый семестр менеджмент')),
    ('Деревообработка',
    (SELECT id from semester WHERE title='Ворой семестр столярное дело'))
ON CONFLICT (title) DO UPDATE SET title=course.title;

INSERT INTO public.course_program (course_id, "description")
VALUES
    ((SELECT id from course WHERE title='Теория государства и права'),
    'Тут программа курса Теория государства и права'),
    ((SELECT id from course WHERE title='История государства и права России'),
    'Тут программа курса История государства и права России'),
    ((SELECT id from course WHERE title='Математика'),
    'Тут программа курса Математика'),
    ((SELECT id from course WHERE title='Бухгалтерия'),
    'Тут программа курса Бухгалтерия для экономистов'),
    ((SELECT id from course WHERE title='Мат анализ'),
    'Тут программа курса Бухгалтерия дл менеджеров'),
    ((SELECT id from course WHERE title='Деревообработка'),
    'Тут программа курса Деревообработка')
ON CONFLICT ("description") DO UPDATE SET "description"=course_program."description";

INSERT INTO public.teacher_course (teacher_id, course_id)
SELECT *
FROM (VALUES
    ((SELECT id from teacher WHERE last_name='Шутко'),
    (SELECT id from course WHERE title='Теория государства и права')),
    ((SELECT id from teacher WHERE last_name='Иванов'),
    (SELECT id from course WHERE title='История государства и права России')),
    ((SELECT id from teacher WHERE last_name='Жёлтый'),
    (SELECT id from course WHERE title='Математика')),
    ((SELECT id from teacher WHERE last_name='Жёлтый'),
    (SELECT id from course WHERE title='Бухгалтерия')),
    ((SELECT id from teacher WHERE last_name='Жёлтый'),
    (SELECT id from course WHERE title='Мат анализ')),
    ((SELECT id from teacher WHERE last_name='Шутко'),
    (SELECT id from course WHERE title='Деревообработка')),
    ((SELECT id from teacher WHERE last_name='Жёлтый'),
    (SELECT id from course WHERE title='Деревообработка'))
) AS values_inserted(teacher_id, course_id)
WHERE NOT EXISTS (SELECT * FROM public.teacher_course 
    WHERE teacher_course.teacher_id=values_inserted.teacher_id 
    AND teacher_course.course_id=values_inserted.course_id);

INSERT INTO public.department (title, faculty_id)
SELECT *
FROM (VALUES
    ('Очное', (SELECT id from faculty WHERE title='Факультет права')),
    ('Заочное', (SELECT id from faculty WHERE title='Факультет права')),
    ('Очное', (SELECT id from faculty WHERE title='Факультет высшей экономики и менеджмента')),
    ('Заочное', (SELECT id from faculty WHERE title='Факультет высшей экономики и менеджмента')),
    ('Дневное', (SELECT id from faculty WHERE title='Факультет столярного дела')),
    ('Вечернее', (SELECT id from faculty WHERE title='Факультет столярного дела'))
) AS values_inserted(title, faculty_id)
WHERE NOT EXISTS (SELECT * FROM public.department 
    WHERE department.title=values_inserted.title 
    AND department.faculty_id=values_inserted.faculty_id);

INSERT INTO public."group" (title, department_id, semester_id)
VALUES
    ('23Б',
    (SELECT id from department WHERE title='Очное'
    AND faculty_id=(SELECT id from faculty WHERE title='Факультет права')),
    (SELECT id from semester WHERE title='Первый семестр право')),
    ('17А',
    (SELECT id from department WHERE title='Очное'
    AND faculty_id=(SELECT id from faculty WHERE title='Факультет высшей экономики и менеджмента')),
    (SELECT id from semester WHERE title='Первый семестр экономика')),
    ('43Ю',
    (SELECT id from department WHERE title='Дневное'
    AND faculty_id=(SELECT id from faculty WHERE title='Факультет столярного дела')),
    (SELECT id from semester WHERE title='Первый семестр менеджмент'))
ON CONFLICT (title) DO UPDATE SET title="group".title;

INSERT INTO public.student ("name", surname, last_name, group_id)
SELECT *
FROM (VALUES
    ('Алексей', 'Анатольевич', 'Александров', (SELECT id from "group" WHERE title='23Б')),
    ('Андрей', 'Никитич', 'Никитин', (SELECT id from "group" WHERE title='23Б')),
    ('Александр', 'Евгеньевич', 'Ждановский', (SELECT id from "group" WHERE title='17А')),
    ('Юлия', 'Андреевна', 'Змеева', (SELECT id from "group" WHERE title='43Ю')),
    ('Елена', 'Сергеевна', 'Хорошева', (SELECT id from "group" WHERE title='43Ю')),
    ('Максим', 'Сергеевич', 'Жёлтый', (SELECT id from "group" WHERE title='17А'))
) AS values_inserted("name", surname, last_name, group_id)
WHERE NOT EXISTS (SELECT * FROM public.student 
    WHERE student."name"=values_inserted."name" 
    AND student.surname=values_inserted.surname
    AND student.last_name=values_inserted.last_name
    AND student.group_id=values_inserted.group_id);

INSERT INTO public.exam (title, teacher_id, course_id)
VALUES
    ('Экзамен по праву', (SELECT id from teacher WHERE last_name='Шутко'),
    (SELECT id from course WHERE title='Теория государства и права')),
    ('Экзамен по математике', (SELECT id from teacher WHERE last_name='Жёлтый'),
    (SELECT id from course WHERE title='Математика')),
    ('Экзамен по деревообработке', (SELECT id from teacher WHERE last_name='Шутко'),
    (SELECT id from course WHERE title='Деревообработка'))
ON CONFLICT (title) DO UPDATE SET title=exam.title;

INSERT INTO public.personal_task (title, "description", group_id, teacher_id, assigment_date)
SELECT *
FROM (VALUES
    ('Задание по деревообработке',
    'Обработать кусок дерева',
    (SELECT id from "group" WHERE title='43Ю'),
    (SELECT id from teacher WHERE last_name='Шутко'),
    '2022-12-27'::date),
    ('Задание по праву',
    'Выучить римское право',
    (SELECT id from "group" WHERE title='17А'),
    (SELECT id from teacher WHERE last_name='Иванов'),
    '2020-12-27'::date),
    ('Задание по деревообработке 2',
    'Обработать другой кусок дерева',
    (SELECT id from "group" WHERE title='43Ю'),
    (SELECT id from teacher WHERE last_name='Шутко'),
    '2023-05-27'::date)
) AS values_inserted(title, "description", group_id, teacher_id)
WHERE NOT EXISTS (SELECT * FROM public.personal_task 
    WHERE personal_task.title=values_inserted.title 
    AND personal_task."description"=values_inserted."description"
    AND personal_task.group_id=values_inserted.group_id
    AND personal_task.teacher_id=values_inserted.teacher_id);

INSERT INTO public.grade (points, student_id, exam_id)
SELECT *
FROM (VALUES
    (5,
    (SELECT id from student WHERE "name"='Алексей' AND surname='Анатольевич' AND last_name='Александров'),
    (SELECT id from exam WHERE title='Экзамен по праву')),
    (4,
    (SELECT id from student WHERE "name"='Андрей' AND surname='Никитич' AND last_name='Никитин'),
    (SELECT id from exam WHERE title='Экзамен по праву')),
    (3,
    (SELECT id from student WHERE "name"='Александр' AND surname='Евгеньевич' AND last_name='Ждановский'),
    (SELECT id from exam WHERE title='Экзамен по математике')),
    (5,
    (SELECT id from student WHERE "name"='Юлия' AND surname='Андреевна' AND last_name='Змеева'),
    (SELECT id from exam WHERE title='Экзамен по деревообработке')),
    (4,
    (SELECT id from student WHERE "name"='Елена' AND surname='Сергеевна' AND last_name='Хорошева'),
    (SELECT id from exam WHERE title='Экзамен по деревообработке')),
    (3,
    (SELECT id from student WHERE "name"='Максим' AND surname='Сергеевич' AND last_name='Жёлтый'),
    (SELECT id from exam WHERE title='Экзамен по математике'))
) AS values_inserted(points, student_id, exam_id)
WHERE NOT EXISTS (SELECT * FROM public.grade 
    WHERE grade.points=values_inserted.points 
    AND grade.student_id=values_inserted.student_id
    AND grade.exam_id=values_inserted.exam_id);

INSERT INTO public.schedule (date_time, auditorium_id, course_id, group_id)
SELECT *
FROM (VALUES
    ('2023-07-25 09:30:00'::timestamp,
    (SELECT id from auditorium WHERE "number"=110 and building_id=(SELECT id from building WHERE title='Корпус 1')),
    (SELECT id from course WHERE title='Теория государства и права'),
    (SELECT id from "group" WHERE title='23Б')),
    ('2023-07-25 12:00:00'::timestamp,
    (SELECT id from auditorium WHERE "number"=213 and building_id=(SELECT id from building WHERE title='Корпус 2')),
    (SELECT id from course WHERE title='Теория государства и права'),
    (SELECT id from "group" WHERE title='23Б')),
    ('2023-08-25 09:30:00'::timestamp,
    (SELECT id from auditorium WHERE "number"=113 and building_id=(SELECT id from building WHERE title='Корпус 3')),
    (SELECT id from course WHERE title='Математика'),
    (SELECT id from "group" WHERE title='17А')),
    ('2023-08-25 09:30:00'::timestamp,
    (SELECT id from auditorium WHERE "number"=364 and building_id=(SELECT id from building WHERE title='Корпус 2')),
    (SELECT id from course WHERE title='Деревообработка'),
    (SELECT id from "group" WHERE title='43Ю'))
) AS values_inserted(date_time, auditorium_id, course_id, group_id)
WHERE NOT EXISTS (SELECT * FROM public.schedule 
    WHERE schedule.auditorium_id=values_inserted.auditorium_id
    AND schedule.course_id=values_inserted.course_id
    AND schedule.group_id=values_inserted.group_id);