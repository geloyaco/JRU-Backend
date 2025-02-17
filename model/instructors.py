from fastapi import Depends, HTTPException, APIRouter
from pydantic import BaseModel
from .db import get_db

router = APIRouter()

# ✅ Pydantic Models
class CourseResponse(BaseModel):
    course_id: int
    course_name: str
    section: str
    class_schedule: str

from typing import Optional  # ✅ Add this import


class InstructorResponse(BaseModel):
    instructor_id: int
    user_id: Optional[int]  # Allow None values
    name: str
    hire_date: Optional[str]
    department: Optional[str]
    courses: list["CourseResponse"]

# ✅ Get all instructors
@router.get("/instructors/")
async def get_instructors(db_dep=Depends(get_db)):
    db, conn = db_dep
    if not db:
        raise HTTPException(status_code=500, detail="Database connection failed")

    db.execute("SELECT instructor_id, user_id, name, hire_date, department FROM instructors")
    instructors = db.fetchall()

    return instructors

# ✅ Get instructor with courses
@router.get("/instructors/{instructor_id}", response_model=InstructorResponse)
async def get_instructor(instructor_id: int, db_dep=Depends(get_db)):
    db, conn = db_dep

    # Fetch instructor details
    db.execute("SELECT instructor_id, user_id, name, hire_date, department FROM instructors WHERE instructor_id = %s", (instructor_id,))
    instructor = db.fetchone()
    
    if not instructor:
        raise HTTPException(status_code=404, detail="Instructor not found")

    # Fetch courses linked to the user_id (not instructor_id)
    db.execute("""
        SELECT course_id, course_name, section, class_schedule, user_id
        FROM courses
        WHERE user_id = %s
    """, (instructor["user_id"],))
    courses = db.fetchall()

    return {
        "instructor_id": instructor["instructor_id"],
        "user_id": instructor["user_id"],
        "name": instructor["name"],
        "hire_date": str(instructor["hire_date"]) if instructor["hire_date"] else None,
        "department": instructor["department"],
        "courses": courses  # ✅ Now courses are linked to user_id
    }


@router.post("/instructors/")
async def create_instructor(user_id: int, name: str, department: str, db_dep=Depends(get_db)):
    db, conn = db_dep
    db.execute("INSERT INTO instructors (user_id, name, department) VALUES (%s, %s, %s)", (user_id, name, department))
    conn.commit()
    return {"message": "Instructor created successfully"}

@router.delete("/instructors/{instructor_id}")
async def delete_instructor(instructor_id: int, db_dep=Depends(get_db)):
    db, conn = db_dep
    db.execute("DELETE FROM instructors WHERE instructor_id = %s", (instructor_id,))
    conn.commit()
    return {"message": "Instructor deleted successfully"}
