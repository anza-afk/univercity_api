from database import Base

Building = Base.classes.building
Teacher = Base.classes.teacher
Auditorium = Base.classes.auditorium
Faculty = Base.classes.faculty
Syllabus = Base.classes.syllabus
Semester = Base.classes.semester
Building = Base.classes.building
Course = Base.classes.course
Course_program = Base.classes.course_program
Teacher_course = Base.classes.teacher_course
Department = Base.classes.department
Group = Base.classes.group
Student = Base.classes.student
Exam = Base.classes.exam
Grade = Base.classes.grade
Schedule = Base.classes.schedule


def as_dict(obj):
    data = obj.__dict__
    data.pop('_sa_instance_state')
    return data


for model in [
    Building,
    Teacher,
    Auditorium,
    Faculty,
    Syllabus,
    Semester,
    Building,
    Course,
    Course_program,
    Teacher_course,
    Department,
    Group,
    Student,
    Exam,
    Grade,
    Schedule
]:
    model.as_dict = as_dict
