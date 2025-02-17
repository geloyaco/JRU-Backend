from fastapi import Depends, HTTPException, APIRouter
from pydantic import BaseModel
from .db import get_db
from typing import Optional

router = APIRouter()

# ✅ Pydantic Models
class StudentResponse(BaseModel):
    student_id: int
    user_id: int
    name: str
    enrollment_date: Optional[str]

class CourseAssignRequest(BaseModel):
    course_id: int
    student_id: int


# ✅ Get all students
@router.get("/students/")
async def get_students(db_dep=Depends(get_db)):
    db, conn = db_dep
    db.execute("""
        SELECT user_id AS student_id, name, email
        FROM users WHERE role = 'student'""")
    students = db.fetchall()
    return students

# ✅ Get student by ID (linked to users)
@router.get("/students/{student_id}", response_model=StudentResponse)
async def get_student(student_id: int, db_dep=Depends(get_db)):
    db, conn = db_dep
    db.execute("""
        SELECT user_id AS student_id, name, email
        FROM users WHERE user_id = %s AND role = 'student'""", (student_id,))
    student = db.fetchone()
    if not student:
        raise HTTPException(status_code=404, detail="Student not found")
    return student

# ✅ Create a new student and link to users table
# ✅ Assign student to a course
@router.post("/assign_student_to_course/")
async def assign_student_to_course(request: CourseAssignRequest, db_dep=Depends(get_db)):
    db, conn = db_dep

    # Ensure the student exists in users and has a student role
    db.execute("SELECT user_id FROM users WHERE user_id = %s AND role = 'student'", (request.student_id,))
    student = db.fetchone()
    if not student:
        raise HTTPException(status_code=404, detail="Student not found or not a valid student user")

    # Ensure the course exists
    db.execute("SELECT course_id FROM courses WHERE course_id = %s", (request.course_id,))
    course = db.fetchone()
    if not course:
        raise HTTPException(status_code=404, detail="Course not found")

    # Check if student is already assigned
    db.execute("SELECT * FROM student_courses WHERE student_id = %s AND course_id = %s", (request.student_id, request.course_id))
    if db.fetchone():
        raise HTTPException(status_code=400, detail="Student is already enrolled in this course")

    # Assign student to the course
    db.execute("INSERT INTO student_courses (student_id, course_id) VALUES (%s, %s)", (request.student_id, request.course_id))
    conn.commit()

    return {"message": "Student successfully assigned to course"}
# ✅ Delete student
@router.delete("/students/{student_id}")
async def delete_student(student_id: int, db_dep=Depends(get_db)):
    db, conn = db_dep
    
    db.execute("DELETE FROM students WHERE student_id = %s", (student_id,))
    conn.commit()
    
    return {"message": "Student deleted successfully"}
