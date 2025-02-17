from fastapi import Depends, HTTPException, APIRouter
from pydantic import BaseModel
from typing import List, Optional
from .db import get_db
from sqlalchemy.orm import Session

router = APIRouter()

# Pydantic Models
from enum import Enum
class UserRole(str, Enum):
    student = "student"
    faculty = "faculty"
    admin = "admin"

class UserCreate(BaseModel):
    name: str
    email: str
    password: str 
    role: UserRole    

class UserUpdate(BaseModel):
    name: Optional[str] = None
    email: Optional[str] = None
    password: Optional[str] = None
    role: Optional[str] = None

class UserResponse(BaseModel):
    user_id: int
    name: str
    email: str
    role: str
    created_at: str

# 🚀 Get all users (READ)
@router.get("/users/", response_model=List[UserResponse])
async def get_users(db_dep=Depends(get_db)):
    try:
        db, conn = db_dep  
        query = "SELECT user_id, name, email, role, created_at FROM users"
        db.execute(query)
        users = db.fetchall()
        
        return [
            {
                "user_id": user["user_id"],
                "name": user["name"],
                "email": user["email"],
                "role": user["role"],
                "created_at": str(user["created_at"])
            }
            for user in users
        ]
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Database error: {str(e)}")

# 🚀 Get a single user by ID (READ)
@router.get("/users/{user_id}", response_model=UserResponse)
async def get_user(user_id: int, db=Depends(get_db)):
    query = "SELECT user_id, name, email, role, created_at FROM users WHERE user_id = %s"
    db.execute(query, (user_id,))
    user = db.fetchone()
    
    if user:
        return {
            "user_id": user[0],
            "name": user[1],
            "email": user[2],
            "role": user[3],
            "created_at": str(user[4])
        }
    
    raise HTTPException(status_code=404, detail="User not found")

# 🚀 Create a new user (CREATE)
@router.post("/users/", response_model=UserResponse)
async def create_user(user: UserCreate, db_dep=Depends(get_db)):
    db, conn = db_dep

    # Check if the email already exists
    db.execute("SELECT user_id FROM users WHERE email = %s", (user.email,))
    if db.fetchone():
        raise HTTPException(status_code=400, detail="Email is already registered.")

    # Insert User
    query = "INSERT INTO users (name, email, password, role) VALUES (%s, %s, %s, %s)"
    values = (user.name, user.email, user.password, user.role.value)

    try:
        db.execute(query, values)
        conn.commit()
        user_id = db.lastrowid  

        # ✅ Auto-add students to students table
        if user.role == UserRole.student:
            first_name, last_name = user.name.split()[0], user.name.split()[-1] if " " in user.name else ""
            db.execute("INSERT INTO students (user_id, student_number, first_name, last_name) VALUES (%s, %s, %s, %s)", 
                       (user_id, f"SN{user_id:06d}", first_name, last_name))
            conn.commit()
    except Exception as e:
        conn.rollback()
        raise HTTPException(status_code=500, detail=f"Error creating user: {str(e)}")

    return {
        "user_id": user_id,
        "name": user.name,
        "email": user.email,
        "role": user.role.value,
        "created_at": "Just now"
    }

# 🚀 Update a user (UPDATE)
@router.put("/users/{user_id}")
async def update_user(user_id: int, user_update: UserUpdate, db_dep=Depends(get_db)):
    db, conn = db_dep  

    query = "SELECT user_id, role FROM users WHERE user_id = %s"
    db.execute(query, (user_id,))
    existing_user = db.fetchone()
    if not existing_user:
        raise HTTPException(status_code=404, detail="User not found")

    update_data = {key: value for key, value in user_update.dict().items() if value is not None}
    if not update_data:
        raise HTTPException(status_code=400, detail="No fields provided for update")

    set_clause = ", ".join(f"{key} = %s" for key in update_data.keys())
    values = list(update_data.values()) + [user_id]

    query = f"UPDATE users SET {set_clause} WHERE user_id = %s"

    try:
        db.execute(query, values)
        conn.commit()

        # If role is changed to student, ensure they exist in students table
        if "role" in update_data and update_data["role"] == "student":
            first_name, last_name = update_data.get("name", "").split()[0], update_data.get("name", "").split()[-1] if " " in update_data.get("name", "") else ""
            db.execute("INSERT IGNORE INTO students (user_id, student_number, first_name, last_name) VALUES (%s, %s, %s, %s)", 
                       (user_id, f"SN{user_id:06d}", first_name, last_name))
            conn.commit()
    except Exception as e:
        conn.rollback()
        raise HTTPException(status_code=500, detail=f"Database error: {str(e)}")

    return {"message": "User updated successfully"}

# 🚀 Delete a user (DELETE)
@router.delete("/users/{user_id}")
async def delete_user(user_id: int, db_dep=Depends(get_db)):
    db, conn = db_dep

    # Check if user exists before deleting
    db.execute("SELECT user_id FROM users WHERE user_id = %s", (user_id,))
    if not db.fetchone():
        raise HTTPException(status_code=404, detail="User not found")

    try:
        # Delete from students if they exist
        db.execute("DELETE FROM students WHERE user_id = %s", (user_id,))
        db.execute("DELETE FROM users WHERE user_id = %s", (user_id,))
        conn.commit()
    except Exception as e:
        conn.rollback()
        raise HTTPException(status_code=500, detail=f"Database error: {str(e)}")

    return {"message": "User deleted successfully"}
