from fastapi import APIRouter, Depends, HTTPException
from pydantic import BaseModel
from .db import get_db  # Import database dependency

router = APIRouter()

# Pydantic Models
class LoginRequest(BaseModel):
    email: str
    password: str

class CourseResponse(BaseModel):
    course_id: int
    course_name: str
    section: str
    class_schedule: str

class LoginResponse(BaseModel):
    user_id: int
    name: str
    email: str
    role: str
    courses: list[CourseResponse]  # Ensures courses return correctly

@router.post("/login/", response_model=LoginResponse)
async def login_user(login_data: LoginRequest, db_dep=Depends(get_db)):
    cursor, _ = db_dep  

    print("🔍 Received login request:", login_data.email, login_data.password)  # Debugging

    query = "SELECT user_id, name, email, password, role FROM users WHERE email = %s"
    cursor.execute(query, (login_data.email,))
    user = cursor.fetchone()

    print("📌 User from DB:", user)  # Debugging

    if not user:
        print("❌ User not found")
        raise HTTPException(status_code=401, detail="Invalid email or password")

    # Make sure passwords match (trim spaces)
    if login_data.password.strip() != user["password"].strip():
        print("❌ Password mismatch")
        raise HTTPException(status_code=401, detail="Invalid email or password")

    print("✅ Login successful!")  # Debugging

    return {
        "user_id": user["user_id"],
        "name": user["name"],
        "email": user["email"],
        "role": user["role"],
        "courses": []
    }
