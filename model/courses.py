from fastapi import Depends, HTTPException, APIRouter
from pydantic import BaseModel
from .db import get_db
from typing import Optional

router = APIRouter()

# ✅ Schema

class CourseCreate(BaseModel):
    course_name: str
    section: str
    user_id: int  # Instructor ID
    class_schedule: str

class CourseResponse(BaseModel):
    course_id: int
    course_name: str
    section: str
    class_schedule: str
    user_id: int  # ✅ Ensure user_id is included

class CourseUpdate(BaseModel):
    course_name: str
    section: str
    user_id: int  # Updated field
    class_schedule: str



# ✅ CREATE (POST)
@router.post("/courses/")
async def create_course(course: CourseCreate, db=Depends(get_db)):
    cursor, connection = db
    
    # Ensure user exists
    cursor.execute("SELECT user_id FROM users WHERE user_id = %s", (course.user_id,))
    user = cursor.fetchone()
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
    
    try:
        # Insert course into the database
        query = """
            INSERT INTO courses (course_name, section, user_id, class_schedule)
            VALUES (%s, %s, %s, %s)
        """
        cursor.execute(query, (course.course_name, course.section, course.user_id, course.class_schedule))
        connection.commit()

        course_id = cursor.lastrowid
        if not course_id:
            raise HTTPException(status_code=500, detail="Failed to retrieve course ID.")
        
        # ✅ Correctly indented line
        
    
    except Exception as e:
        connection.rollback()
        raise HTTPException(status_code=500, detail=f"Error inserting course: {str(e)}")


# ✅ READ ALL (GET)
@router.get("/courses/")
async def read_courses(user_id: int, db=Depends(get_db)):  
    cursor, _ = db

    # ✅ Ensure user exists
    cursor.execute("SELECT role FROM users WHERE user_id = %s", (user_id,))
    user = cursor.fetchone()

    if not user:
        raise HTTPException(status_code=404, detail="User not found")

    # ✅ Convert result to a dictionary
    user_role = user[0] if isinstance(user, tuple) else user.get("role", "")

    if user_role != "faculty":
        raise HTTPException(status_code=403, detail="Access restricted to faculty users")

    # ✅ Fetch courses linked to the faculty user
    query = """
        SELECT course_id, course_name, section, class_schedule, user_id
        FROM courses
        WHERE user_id = %s
    """
    cursor.execute(query, (user_id,))
    courses = cursor.fetchall()

    if not courses:
        raise HTTPException(status_code=404, detail="No courses found.")

    return [
        {
            "course_id": course["course_id"],
            "course_name": course["course_name"],
            "section": course["section"],
            "class_schedule": course["class_schedule"],
            "user_id": course["user_id"]
        }
        for course in courses
    ]

@router.get("/course_students/{course_id}")
async def get_students_in_course(course_id: int, db_dep=Depends(get_db)):
    db, conn = db_dep

    # Check if course exists
    db.execute("SELECT course_id FROM courses WHERE course_id = %s", (course_id,))
    if not db.fetchone():
        raise HTTPException(status_code=404, detail="Course not found")

    # Fetch students enrolled in the course
    query = """
        SELECT u.user_id AS student_id, u.name, u.email
        FROM student_courses sc
        JOIN users u ON sc.student_id = u.user_id
        WHERE sc.course_id = %s AND u.role = 'student'
    """
    db.execute(query, (course_id,))
    students = db.fetchall()

    return {"course_id": course_id, "students": students}

# ✅ UPDATE (PUT)
@router.put("/courses/{course_id}")
async def update_course(course_id: int, course: CourseUpdate, db=Depends(get_db)):
    cursor, connection = db

    # Ensure course exists
    cursor.execute("SELECT user_id FROM courses WHERE course_id = %s", (course_id,))
    existing_course = cursor.fetchone()
    if not existing_course:
        raise HTTPException(status_code=404, detail="Course not found")
    
    if existing_course["user_id"] != course.user_id:
        raise HTTPException(status_code=403, detail="You do not have permission to update this course")

    query = "UPDATE courses SET course_name = %s, section = %s, user_id = %s, class_schedule = %s WHERE course_id = %s"
    cursor.execute(query, (course.name, course.section, course.user_id, course.class_schedule, course_id))
    connection.commit()
    return {"message": "Course updated successfully"}

# ✅ DELETE (DELETE)
@router.delete("/courses/{course_id}")
async def delete_course(course_id: int, user_id: int, db=Depends(get_db)):
    cursor, connection = db

    # Ensure the course belongs to the user
    cursor.execute("SELECT user_id FROM courses WHERE course_id = %s", (course_id,))
    existing_course = cursor.fetchone()
    if not existing_course:
        raise HTTPException(status_code=404, detail="Course not found")

    if existing_course["user_id"] != user_id:
        raise HTTPException(status_code=403, detail="You do not have permission to delete this course")

    query = "DELETE FROM courses WHERE course_id = %s"
    cursor.execute(query, (course_id,))
    connection.commit()
    return {"message": "Course deleted successfully"}