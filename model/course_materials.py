# model/course_materials.py
from fastapi import Depends, HTTPException, APIRouter
from pydantic import BaseModel
from .db import get_db

router = APIRouter()

class CourseMaterialCreate(BaseModel):
    course_id: int
    user_id: int  # Changed from instructor_id to user_id
    content_id: int
    title: str
    content: str



@router.post("/course_materials/")
async def create_material(material: CourseMaterialCreate, db=Depends(get_db)):
    cursor, connection = db

    # Ensure user exists
    cursor.execute("SELECT user_id FROM users WHERE user_id = %s", (material.user_id,))
    if not cursor.fetchone():
        raise HTTPException(status_code=404, detail="User not found")

    # Ensure course content exists
    cursor.execute("SELECT content_id FROM course_content WHERE content_id = %s", (material.content_id,))
    if not cursor.fetchone():
        raise HTTPException(status_code=404, detail="Course content not found")

    # Insert course material linked to user_id
    query = """
    INSERT INTO course_materials (course_id, user_id, content_id, title, content) 
    VALUES (%s, %s, %s, %s, %s)
    """
    cursor.execute(query, (material.course_id, material.user_id, material.content_id, material.title, material.content))
    connection.commit()

    return {"message": "Material added successfully"}

@router.get("/course_materials/{course_id}")
async def get_materials(course_id: int, db=Depends(get_db)):
    cursor, _ = db

    # Fetch course name
    cursor.execute("SELECT course_name FROM courses WHERE course_id = %s", (course_id,))
    course = cursor.fetchone()
    if not course:
        raise HTTPException(status_code=404, detail="Course not found")

    course_name = course["course_name"]

    # Fetch all course content and its associated user
    cursor.execute("""
        SELECT cc.content_id, cc.title, cc.content, cc.file_path, u.user_id, u.name AS user_name
        FROM course_content cc
        JOIN users u ON cc.user_id = u.user_id
        WHERE cc.course_id = %s
    """, (course_id,))

    course_contents = cursor.fetchall()

    return {
        "course_name": course_name,
        "materials": [
            {
                "content_id": content["content_id"],
                "title": content["title"],
                "content": content["content"],
                "file_path": content["file_path"],
                "user_id": content["user_id"],
                "user_name": content["user_name"]
            }
            for content in course_contents
        ]
    }
