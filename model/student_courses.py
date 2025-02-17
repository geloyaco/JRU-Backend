from fastapi import Depends, HTTPException, APIRouter
from pydantic import BaseModel
from .db import get_db

router = APIRouter()

class StudentCourseEnroll(BaseModel):
    user_id: int
    course_id: int

# ✅ Enroll Student in a Course
@router.post("/student_courses/")
async def enroll_student(enrollment: StudentCourseEnroll, db_dep=Depends(get_db)):
    db, conn = db_dep

    # Check if user exists
    db.execute("SELECT user_id FROM users WHERE user_id = %s", (enrollment.user_id,))
    if not db.fetchone():
        raise HTTPException(status_code=400, detail="User not found")

    # Check if course exists
    db.execute("SELECT course_id FROM courses WHERE course_id = %s", (enrollment.course_id,))
    if not db.fetchone():
        raise HTTPException(status_code=400, detail="Course not found")

    # Insert enrollment using user_id directly
    query = "INSERT INTO student_courses (student_id, course_id) VALUES (%s, %s)"
    db.execute(query, (enrollment.user_id, enrollment.course_id))
    conn.commit()

    return {"message": "Student enrolled successfully"}

# ✅ Get Courses a Student is Enrolled In
@router.get("/course_students/{course_id}")
async def get_students_in_course(course_id: int, db_dep=Depends(get_db)):
    db, conn = db_dep

    # Check if course exists
    db.execute("SELECT course_id FROM courses WHERE course_id = %s", (course_id,))
    if not db.fetchone():
        raise HTTPException(status_code=404, detail="Course not found")

    # Fetch students enrolled in the course
    query = """
        SELECT s.student_id, s.user_id, s.first_name, s.last_name
        FROM student_courses sc
        JOIN students s ON sc.student_id = s.student_id
        WHERE sc.course_id = %s
    """
    db.execute(query, (course_id,))
    students = db.fetchall()

    return {"course_id": course_id, "students": students}