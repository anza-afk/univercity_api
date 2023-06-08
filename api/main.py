from fastapi import (
    FastAPI,
    Depends,
)
from sqlalchemy.orm import Session
from typing import List

import crud
import schemas
import models
from database import SessionLocal


app = FastAPI(title="Univercity API")


def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()


@app.post('/students/', response_model=schemas.Student)
def create_student(
    student: schemas.StudentBase,
    db: Session = Depends(get_db)
) -> models.Student:
    return crud.create_student(db=db, student=student)


@app.get('/students/{student_id}', response_model=schemas.Student)
def get_student(
    student_id: int,
    db: Session = Depends(get_db)
) -> models.Student:
    return crud.get_student(db=db, student_id=student_id)


@app.put('/students/{student_id}', response_model=schemas.Student)
def update_student(
    student_id: int,
    student: schemas.StudentBase,
    db: Session = Depends(get_db)
) -> models.Student:
    return crud.update_student(db=db, student_id=student_id, student=student)


@app.delete('/students/{student_id}', response_model=schemas.Student)
def delete_student(student_id: int, db: Session = Depends(get_db)) -> dict:
    return crud.delete_student(db=db, student_id=student_id)


@app.get('/teachers', response_model=List[schemas.Teacher])
def get_teachers(
    skip: int = 0,
    limit: int = 100,
    db: Session = Depends(get_db)
) -> List[models.Teacher]:
    return crud.get_teachers(db=db, skip=skip, limit=limit)


@app.post('/courses/', response_model=schemas.Course)
def create_coursse(
    course: schemas.CourseBase,
    db: Session = Depends(get_db)
) -> models.Course:
    return crud.create_course(db=db, course=course)


@app.get('/courses/{course_id}', response_model=schemas.Course)
def get_course(course_id: int, db: Session = Depends(get_db)) -> models.Course:
    return crud.get_course(db=db, course_id=course_id)


@app.get('/courses/{course_id}/students', response_model=List[schemas.Student])
def get_course_student(
    course_id: int,
    skip: int = 0,
    limit: int = 100,
    db: Session = Depends(get_db)
) -> List[models.Student]:
    return crud.get_course_students(
        db=db,
        course_id=course_id,
        skip=skip,
        limit=limit
    )


@app.post('/grades/', response_model=schemas.Grade)
def create_grade(
    grade: schemas.GradeBase,
    db: Session = Depends(get_db)
) -> models.Grade:
    return crud.create_grade(db=db, grade=grade)


@app.put('/grades/{grade_id}', response_model=schemas.Grade)
def update_grade(
    grade_id: int,
    grade: schemas.GradeBase,
    db: Session = Depends(get_db)
) -> models.Grade:
    return crud.update_grade(db=db, grade_id=grade_id, grade=grade)
