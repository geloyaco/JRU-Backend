from fastapi import Depends, HTTPException, APIRouter, Path, Form, File, UploadFile
from pydantic import BaseModel
import os
from .db import get_db

router = APIRouter()

UPLOAD_DIR = "uploads"
os.makedirs(UPLOAD_DIR, exist_ok=True)  # Ensure the directory exists

# ✅ Schema
class AssignmentCreate(BaseModel):
    course_id: int
    title: str
    description: str
    due_date: str

class AssignmentUpdate(BaseModel):
    title: str
    description: str
    due_date: str

@router.post("/assignments")
async def create_assignment(
    course_id: int = Form(...),
    title: str = Form(...),
    description: str = Form(...),
    due_date: str = Form(...),
    file: UploadFile = File(None),
    db=Depends(get_db)
):
    cursor, connection = db

    # Ensure course exists
    cursor.execute("SELECT user_id FROM courses WHERE course_id = %s", (course_id,))
    course = cursor.fetchone()
    if not course:
        raise HTTPException(status_code=404, detail="Course not found")

    user_id = course["user_id"]

    # Handle file upload
    file_path = None
    if file:
        os.makedirs(UPLOAD_DIR, exist_ok=True)
        file_path = os.path.join(UPLOAD_DIR, file.filename)
        with open(file_path, "wb") as buffer:
            buffer.write(file.file.read())

    # Insert into database
    query = "INSERT INTO assignments (course_id, title, description, due_date, file_path, user_id) VALUES (%s, %s, %s, %s, %s, %s)"
    cursor.execute(query, (course_id, title, description, due_date, file_path, user_id))
    connection.commit()

    assignment_id = cursor.lastrowid
    return {
        "assignment_id": assignment_id,
        "title": title,
        "description": description,
        "due_date": due_date,
        "file_path": file_path,
        "user_id": user_id
    }

# ✅ READ (GET)
@router.get("/assignments/{course_id}")
async def get_assignments(course_id: int, db=Depends(get_db)):
    cursor, _ = db

    cursor.execute("SELECT course_name FROM courses WHERE course_id = %s", (course_id,))
    course = cursor.fetchone()
    if not course:
        raise HTTPException(status_code=404, detail="Course not found")

    course_name = course["course_name"]

    cursor.execute("""
        SELECT a.assignment_id, a.title, a.description, a.due_date, a.file_path, u.name AS instructor_name 
        FROM assignments a
        JOIN users u ON a.user_id = u.user_id
        WHERE a.course_id = %s
    """, (course_id,))

    assignments = cursor.fetchall()

    return {
        "course_name": course_name,
        "assignments": [
            {
                "assignment_id": a["assignment_id"],
                "title": a["title"],
                "description": a["description"],
                "due_date": a["due_date"],
                "file_path": a["file_path"],
                "instructor_name": a["instructor_name"]
            }
            for a in assignments
        ]
    }

# ✅ GET SINGLE ASSIGNMENT
@router.get("/assignments/item/{assignment_id}")
async def get_assignment(assignment_id: int, db=Depends(get_db)):
    cursor, _ = db
    query = "SELECT assignment_id, title, description, due_date FROM assignments WHERE assignment_id = %s"
    cursor.execute(query, (assignment_id,))
    assignment = cursor.fetchone()

    if not assignment:
        raise HTTPException(status_code=404, detail="Assignment not found")

    return {
        "assignment_id": assignment["assignment_id"],
        "title": assignment["title"],
        "description": assignment["description"],
        "due_date": assignment["due_date"]
    }

# ✅ UPDATE (PUT)
@router.put("/assignments/{assignment_id}")
async def update_assignment(assignment_id: int, assignment: AssignmentUpdate, db=Depends(get_db)):
    cursor, connection = db
    query = "UPDATE assignments SET title = %s, description = %s, due_date = %s WHERE assignment_id = %s"
    cursor.execute(query, (assignment.title, assignment.description, assignment.due_date, assignment_id))
    connection.commit()
    if cursor.rowcount == 0:
        raise HTTPException(status_code=404, detail="Assignment not found")
    return {"message": "Assignment updated successfully"}

# ✅ DELETE (DELETE)
@router.delete("/assignments/{assignment_id}")
async def delete_assignment(assignment_id: int, db=Depends(get_db)):
    cursor, connection = db
    query = "DELETE FROM assignments WHERE assignment_id = %s"
    cursor.execute(query, (assignment_id,))
    connection.commit()
    if cursor.rowcount == 0:
        raise HTTPException(status_code=404, detail="Assignment not found")
    return {"message": "Assignment deleted successfully"}
