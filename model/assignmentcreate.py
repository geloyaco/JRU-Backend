from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from pydantic import BaseModel
from datetime import date
from typing import List, Optional

from .db import get_db

router = APIRouter()


# ✅ Pydantic Schema for Assignments
class AssignmentCreate(BaseModel):
    title: str
    due_date: Optional[date] = None
    course_id: int
    user_id: int


class AssignmentResponse(BaseModel):
    assignment_id: int
    title: str
    due_date: Optional[date]
    course_id: int
    user_id: int

    class Config:
        from_attributes = True


# ✅ Fetch Assignments for a Faculty User
@router.get("/assignments/", response_model=List[AssignmentResponse])
def get_assignments(user_id: int, db: Session = Depends(get_db)):
    assignments = db.query(Assignment).filter(Assignment.user_id == user_id).all()
    if not assignments:
        raise HTTPException(status_code=404, detail="No assignments found for this user.")
    return assignments


# ✅ Create an Assignment
@router.post("/assignments/", response_model=AssignmentResponse)
def create_assignment(assignment: AssignmentCreate, db: Session = Depends(get_db)):
    new_assignment = Assignment(
        title=assignment.title,
        due_date=assignment.due_date,
        course_id=assignment.course_id,
        user_id=assignment.user_id,
    )
    db.add(new_assignment)
    db.commit()
    db.refresh(new_assignment)
    return new_assignment


# ✅ Delete an Assignment
@router.delete("/assignments/{assignment_id}")
def delete_assignment(assignment_id: int, user_id: int, db: Session = Depends(get_db)):
    assignment = db.query(Assignment).filter(Assignment.assignment_id == assignment_id, Assignment.user_id == user_id).first()

    if not assignment:
        raise HTTPException(status_code=404, detail="Assignment not found or unauthorized.")

    db.delete(assignment)
    db.commit()
    return {"message": "Assignment deleted successfully."}
