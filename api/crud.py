from fastapi import HTTPException
from sqlalchemy.orm import Session
from typing import List

import models
from schemas import StudentBase, CourseBase


def commit_to_db(db: Session, db_model: models.Base) -> None:
    """
    Утилитарная функция для создания новой записи в бд.
    """
    db.add(db_model)
    db.commit()
    db.refresh(db_model)


def get_student(db: Session, student_id: int):
    """
    Возвращает из БД студента по заданному id.
    """
    return db.query(models.Student).filter(
        models.Student.id == student_id
    ).first()


def create_student(db: Session, student: StudentBase) -> models.Student:
    """
    Создаёт нового студента в БД;
    Возвращает нового студента.
    """
    db_student = models.Student(
        **student.dict(),
    )
    commit_to_db(db=db, db_model=db_student)
    return db_student


def update_student(
    db: Session,
    student_id: int,
    student: StudentBase
) -> models.Student:
    """
    Обновляет данные студента в БД,
    если по данному id есть запись;
    Возвращает студента.
    """
    db_student = db.query(models.Student).filter(
        models.Student.id == student_id
    ).first()
    if not db_student:
        raise HTTPException(
            status_code=404,
            detail=f'Студент с id {student_id} не найден в базе данных'
        )
    else:
        for key, value in student.items():
            setattr(db_student, key, value)
        db.commit()
        db.refresh(db_student)
        return db_student


def delete_student(student_id: int, db: Session) -> dict:
    """
    Удаляет студента из БД;
    Возвращает результат.
    """
    db_student = db.query(models.Student).filter(
        models.Student.id == student_id
    ).first()
    if not db_student:
        raise HTTPException(
            status_code=404,
            detail=f'Студент с id {student_id} не найден в базе данных'
        )
    else:
        db.delete(db_student)
        db.commit()
        return {'ok': True}


def get_teachers(
    db: Session,
    skip: int = 0,
    limit: int = 100
) -> List[models.Teacher]:
    """
    Возвращает список всех учителей.
    """
    return db.query(models.Teacher).offset(skip).limit(limit).all()


def create_course(db: Session, course: CourseBase) -> models.Course:
    """
    Создаёт новогый курс в БД;
    Возвращает новый курс.
    """
    db_course = models.Course(
        **course.dict(),
    )
    commit_to_db(db=db, db_model=db_course)
    return db_course


def get_course(db: Session, course_id: int):
    """
    Возвращает из БД курс по заданному id.
    """
    return db.query(models.Course).filter(
        models.Course.id == course_id
    ).first()


def get_course_students(
    db: Session,
    course_id: int,
    skip: int = 0,
    limit: int = 100
) -> List[models.Student]:
    """
    Возвращает список всех студентов на курсе.
    """
    return db.query(models.Student).\
        join(models.Group).join(models.Semester).join(models.Course).\
        filter(models.Course.id == course_id).offset(skip).limit(limit).all()


def create_grade(db: Session, grade: StudentBase) -> models.Grade:
    """
    Создаёт новоую оценку в БД;
    Возвращает новую оценку.
    """
    db_grade = models.Grade(
        **grade.dict(),
    )
    commit_to_db(db=db, db_model=db_grade)
    return db_grade


def update_grade(
    db: Session,
    grade_id: int,
    grade: StudentBase
) -> models.Grade:
    """
    Обновляет оценку в БД,
    если по данному id есть запись;
    Возвращает оценку.
    """
    db_grade = db.query(models.Grade).filter(
        models.Grade.id == grade_id
    ).first()
    if not db_grade:
        raise HTTPException(
            status_code=404,
            detail=f'Оценка с id {grade_id} не найдена в базе данных'
        )
    else:
        for key, value in grade.items():
            setattr(db_grade, key, value)
        db.commit()
        db.refresh(db_grade)
        return db_grade
