from pydantic import BaseModel
from datetime import datetime, date


class BuildingBase(BaseModel):
    title: str
    building_number: int | None

    class Config:
        orm_mode = True


class Building(BuildingBase):
    id: int


class TeacherBase(BaseModel):
    name: str
    last_name: str
    surname: str | None

    class Config:
        orm_mode = True


class Teacher(TeacherBase):
    id: int


class AuditoriumBase(BaseModel):
    number: int
    building_id: int

    class Config:
        orm_mode = True


class Auditorium(AuditoriumBase):
    id: int


class FacultyBase(BaseModel):
    title: str
    description: str | None
    building_id: int

    class Config:
        orm_mode = True


class Faculty(FacultyBase):
    id: int


class SyllabusBase(BaseModel):
    title: str
    description: str
    faculty_id: int

    class Config:
        orm_mode = True


class Syllabus(SyllabusBase):
    id: int


class SemesterBase(BaseModel):
    title: str
    syllabus_id: int | None

    class Config:
        orm_mode = True


class Semester(SyllabusBase):
    id: int


class CourseBase(BaseModel):
    title: str
    semester_id: int | None

    class Config:
        orm_mode = True


class Course(CourseBase):
    id: int


class CourseProgramBase(BaseModel):
    course_int: int
    description: str

    class Config:
        orm_mode = True


class CourseProgram(CourseProgramBase):
    id: int


class DepartmentBase(BaseModel):
    title: str
    faculty_id: int

    class Config:
        orm_mode = True


class Department(DepartmentBase):
    id: int


class GroupBase(BaseModel):
    title: str
    department_id: int
    semester_id: int

    class Config:
        orm_mode = True


class Group(GroupBase):
    id: int


class StudentBase(BaseModel):
    name: str
    last_name: str
    surname: str | None
    group_id: int

    class Config:
        orm_mode = True


class Student(StudentBase):
    id: int


class ExamBase(BaseModel):
    title: str
    course_id: int
    teacher_id: int | None

    class Config:
        orm_mode = True


class Exam(ExamBase):
    id: int


class PersonalTaskBase(BaseModel):
    title: str
    description: str | None
    assigment_date: date
    group_id: int
    teacher_id: int

    class Config:
        orm_mode = True


class PersonalTask(PersonalTaskBase):
    id: int


class GradeBase(BaseModel):
    points: int
    student_id: int
    exam_id: int

    class Config:
        orm_mode = True


class Grade(GradeBase):
    id: int


class ScheduleBase(BaseModel):
    date_time: datetime
    auditorium_id: int | None
    course_id: int
    group_id: int
    exam_id: int | None

    class Config:
        orm_mode = True


class Schedule(ScheduleBase):
    id: int
