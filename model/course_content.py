from fastapi import Depends, HTTPException, APIRouter, Path, Form, File, UploadFile
from pydantic import BaseModel
import os
from .db import get_db

router = APIRouter()

UPLOAD_DIR = "uploads"
os.makedirs(UPLOAD_DIR, exist_ok=True)  # Ensure the directory exists

# ✅ Schema
class CourseContentCreate(BaseModel):
    course_id: int
    title: str
    content: str

class CourseContentUpdate(BaseModel):
    title: str
    content: str

@router.post("/course-content")
async def create_course_content(
    course_id: int = Form(...),
    title: str = Form(...),
    content: str = Form(...),
    file: UploadFile = File(None),
    db=Depends(get_db)
):
    cursor, connection = db

    # Ensure course exists and fetch user ID
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
    query = "INSERT INTO course_content (course_id, title, content, file_path, user_id) VALUES (%s, %s, %s, %s, %s)"
    cursor.execute(query, (course_id, title, content, file_path, user_id))
    connection.commit()

    content_id = cursor.lastrowid
    return {
        "content_id": content_id,
        "title": title,
        "content": content,
        "file_path": file_path,
        "user_id": user_id
    }

# ✅ READ (GET)
@router.get("/course-content/{course_id}")
async def get_course_content(course_id: int = Path(..., title="Course ID"), db=Depends(get_db)):
    cursor, _ = db

    # Fetch course name
    cursor.execute("SELECT course_name FROM courses WHERE course_id = %s", (course_id,))
    course = cursor.fetchone()
    if not course:
        raise HTTPException(status_code=404, detail="Course not found")

    course_name = course["course_name"]

    # Fetch course content and join with users table to get the name
    cursor.execute("""
        SELECT cc.content_id, cc.title, cc.content, cc.file_path, u.name AS instructor_name 
        FROM course_content cc
        JOIN users u ON cc.user_id = u.user_id
        WHERE cc.course_id = %s
    """, (course_id,))

    contents = cursor.fetchall()

    return {
        "course_name": course_name,
        "data": [
            {
                "content_id": content["content_id"],
                "title": content["title"],
                "content": content["content"],
                "file_path": content["file_path"],
                "instructor_name": content["instructor_name"]  # Now fetching from `users.name`
            }
            for content in contents
        ]
    }


@router.get("/course-content/item/{content_id}")
async def get_content_item(content_id: int, db=Depends(get_db)):
    cursor, _ = db
    query = "SELECT content_id, title, content FROM course_content WHERE content_id = %s"
    cursor.execute(query, (content_id,))
    content = cursor.fetchone()

    if not content:
        raise HTTPException(status_code=404, detail="Content not found")

    return {
        "content_id": content["content_id"],
        "title": content["title"],
        "content": content["content"]
    }

# ✅ UPDATE (PUT)
@router.put("/course-content/{content_id}")
async def update_course_content(content_id: int, content: CourseContentUpdate, db=Depends(get_db)):
    cursor, connection = db
    query = "UPDATE course_content SET title = %s, content = %s WHERE content_id = %s"
    cursor.execute(query, (content.title, content.content, content_id))
    connection.commit()
    if cursor.rowcount == 0:
        raise HTTPException(status_code=404, detail="Content not found")
    return {"message": "Course content updated successfully"}

# ✅ DELETE (DELETE)
@router.delete("/course-content/{content_id}")
async def delete_course_content(content_id: int, db=Depends(get_db)):
    cursor, connection = db
    query = "DELETE FROM course_content WHERE content_id = %s"
    cursor.execute(query, (content_id,))
    connection.commit()
    if cursor.rowcount == 0:
        raise HTTPException(status_code=404, detail="Content not found")
    return {"message": "Course content deleted successfully"}
