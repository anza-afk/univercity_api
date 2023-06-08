-- Выбрать всех студентов, обучающихся на курсе 'Математика'
SELECT s.name, s.surname, s.last_name
FROM student AS s
JOIN "group" AS g ON s.group_id = g.id
JOIN semester AS sem ON g.semester_id = sem.id
JOIN course AS c ON sem.id = c.semester_id AND c.title = 'Математика';

-- Обновить оценку студента по курсу.
UPDATE grade
SET points = 7
WHERE student_id = 37
AND exam_id = 19

-- Выбрать всех преподавателей, которые преподают в здании №3.
SELECT t.name, t.surname, t.last_name
FROM teacher AS t
JOIN teacher_course AS tc ON t.id = tc.teacher_id
JOIN course AS c ON tc.course_id = c.id
JOIN semester AS sem ON c.semester_id = sem.id
JOIN syllabus AS syl ON sem.syllabus_id = syl.id
JOIN faculty AS f ON syl.faculty_id = f.id
JOIN building AS b ON f.building_id = b.id AND b.building_number = 3;

-- Удалить задание для самостоятельной работы, которое было создано более года назад.
DELETE
FROM personal_task as p
WHERE p.assigment_date < (CAST( NOW() AS Date) - interval '1 year')

-- Добавить новый семестр в учебный год.
INSERT INTO public.semester (title, syllabus_id)
VALUES
    ('Второй семестр экономика',
    (SELECT id from syllabus WHERE title='Учебный план направления высшая экономика'));
