CREATE TABLE IF NOT EXISTS building (
    id int PRIMARY KEY NOT NULL GENERATED ALWAYS AS IDENTITY,
	title varchar NOT NULL UNIQUE,
	building_number int NULL UNIQUE
);


CREATE TABLE IF NOT EXISTS teacher (
	id int PRIMARY KEY NOT NULL GENERATED ALWAYS AS IDENTITY,
	"name" varchar NOT NULL,
	last_name varchar NOT NULL,
	surname varchar NULL
);


CREATE TABLE IF NOT EXISTS auditorium (
	id int PRIMARY KEY NOT NULL GENERATED ALWAYS AS IDENTITY,
	"number" int NOT NULL,
	building_id int NOT NULL,
	CONSTRAINT building_fk FOREIGN KEY (building_id) REFERENCES building(id) ON DELETE CASCADE
);


CREATE TABLE IF NOT EXISTS faculty (
	id int PRIMARY KEY NOT NULL GENERATED ALWAYS AS IDENTITY,
	title varchar NOT NULL UNIQUE,
	building_id int NOT NULL,
	"description" text NULL,
	CONSTRAINT building_fk FOREIGN KEY (building_id) REFERENCES building(id)
);


CREATE TABLE IF NOT EXISTS syllabus (
	id int PRIMARY KEY NOT NULL GENERATED ALWAYS AS IDENTITY,
	title varchar NOT NULL UNIQUE,
	faculty_id int NOT NULL,
	"description" text NULL,
	CONSTRAINT faculty_fk FOREIGN KEY (faculty_id) REFERENCES faculty(id) ON DELETE CASCADE
);


CREATE TABLE IF NOT EXISTS semester (
	id int PRIMARY KEY NOT NULL GENERATED ALWAYS AS IDENTITY,
	title varchar NULL,
	syllabus_id int NULL,
	CONSTRAINT syllabus_fk FOREIGN KEY (syllabus_id) REFERENCES syllabus(id)
);


CREATE TABLE IF NOT EXISTS course (
	id int PRIMARY KEY NOT NULL GENERATED ALWAYS AS IDENTITY,
	title varchar NULL UNIQUE,
	semester_id int NULL,
	CONSTRAINT semester_fk FOREIGN KEY (semester_id) REFERENCES semester(id) ON DELETE CASCADE
);


CREATE TABLE IF NOT EXISTS course_program (
	id int PRIMARY KEY NOT NULL GENERATED ALWAYS AS IDENTITY,
	course_id int NOT NULL,
	"description" varchar NOT NULL UNIQUE,
	CONSTRAINT course_fk FOREIGN KEY (course_id) REFERENCES course(id) ON DELETE CASCADE
);


CREATE TABLE IF NOT EXISTS teacher_course (
	id int PRIMARY KEY NOT NULL GENERATED ALWAYS AS IDENTITY,
	teacher_id int NOT NULL,
	course_id int NOT NULL,
	CONSTRAINT course_fk FOREIGN KEY (course_id) REFERENCES course(id) ON DELETE CASCADE,
	CONSTRAINT teacher_fk FOREIGN KEY (teacher_id) REFERENCES teacher(id) ON DELETE CASCADE
);


CREATE TABLE IF NOT EXISTS department (
	id int PRIMARY KEY NOT NULL GENERATED ALWAYS AS IDENTITY,
	title varchar NOT NULL,
	faculty_id int NOT NULL,
	CONSTRAINT faculty_fk FOREIGN KEY (faculty_id) REFERENCES faculty(id)
);


CREATE TABLE IF NOT EXISTS "group" (
	id int PRIMARY KEY NOT NULL GENERATED ALWAYS AS IDENTITY,
	title varchar NULL UNIQUE,
	department_id int NOT NULL,
	semester_id int NOT NULL,
	CONSTRAINT department_fk FOREIGN KEY (department_id) REFERENCES department(id),
	CONSTRAINT semester_fk FOREIGN KEY (semester_id) REFERENCES semester(id)
);


CREATE TABLE IF NOT EXISTS student (
	id int PRIMARY KEY NOT NULL GENERATED ALWAYS AS IDENTITY,
	"name" varchar NOT NULL,
	last_name varchar NOT NULL,
	surname varchar NULL,
	group_id int NOT NULL,
	CONSTRAINT group_fk FOREIGN KEY (group_id) REFERENCES "group"(id)
);


CREATE TABLE IF NOT EXISTS exam (
	id int PRIMARY KEY NOT NULL GENERATED ALWAYS AS IDENTITY,
	title varchar NOT NULL UNIQUE,
	teacher_id int NULL,
	course_id int NOT NULL,
	CONSTRAINT course_fk FOREIGN KEY (course_id) REFERENCES course(id) ON DELETE CASCADE,
	CONSTRAINT teacher_fk FOREIGN KEY (teacher_id) REFERENCES teacher(id) ON DELETE SET NULL
);


CREATE TABLE IF NOT EXISTS personal_task (
	id int PRIMARY KEY NOT NULL GENERATED ALWAYS AS IDENTITY,
	title varchar NOT NULL,
	"description" text NULL,
	group_id int NOT NULL,
	teacher_id int NOT NULL,
    assigment_date date NOT NULL,
	CONSTRAINT group_fk FOREIGN KEY (group_id) REFERENCES "group"(id) ON DELETE CASCADE,
	CONSTRAINT teacher_fk FOREIGN KEY (teacher_id) REFERENCES teacher(id) ON DELETE CASCADE
);


CREATE TABLE IF NOT EXISTS grade (
	id int PRIMARY KEY NOT NULL GENERATED ALWAYS AS IDENTITY,
	points int NOT NULL,
	student_id int NOT NULL,
	exam_id int NOT NULL,
	CONSTRAINT exam_fk FOREIGN KEY (exam_id) REFERENCES exam(id) ON DELETE CASCADE,
	CONSTRAINT student_fk FOREIGN KEY (student_id) REFERENCES student(id) ON DELETE CASCADE
);


CREATE TABLE IF NOT EXISTS schedule (
	id int PRIMARY KEY NOT NULL GENERATED ALWAYS AS IDENTITY,
	date_time timestamp NOT NULL,
	auditorium_id int NULL,
	course_id int NOT NULL,
	group_id int NOT NULL,
	exam_id int NULL,
	CONSTRAINT auditorium_fk FOREIGN KEY (auditorium_id) REFERENCES auditorium(id) ON DELETE SET NULL,
	CONSTRAINT course_fk FOREIGN KEY (course_id) REFERENCES course(id) ON DELETE CASCADE,
	CONSTRAINT exam_fk FOREIGN KEY (exam_id) REFERENCES exam(id) ON DELETE SET NULL,
	CONSTRAINT group_fk FOREIGN KEY (group_id) REFERENCES "group"(id) ON DELETE CASCADE
);