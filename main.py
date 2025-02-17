from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from model.auth import router as auth_router
from model.users import router as users_router
from model.courses import router as courses_router
from model.course_content import router as course_content_router
from model.course_materials import router as course_materials_router
from model.assignmentcontent import router as assignmentcontent_router
from model.assignmentcreate import router as assignmentcreate_router
from model.assignment_submissions import router as assignment_submissions_router
from model.exams import router as exams_router
from model.exam_submissions import router as exam_submissions_router
from model.quizzes import router as quizzes_router
from model.quiz_submissions import router as quiz_submissions_router
from model.student_courses import router as student_courses_router
from model.grades import router as grades_router
from model.students import router as students_router
from model.instructors import router as instructors_router

app = FastAPI()

# Enable CORS to allow frontend to access the backend
app.add_middleware(
    CORSMiddleware,
    allow_origins=["http://localhost:5173"],  # Allow requests from frontend
    allow_credentials=True,
    allow_methods=["*"],  # Allow all HTTP methods
    allow_headers=["*"],  # Allow all headers
)

# Register Routers with Tags
app.include_router(auth_router, prefix="/api")   # Authentication routes
app.include_router(users_router, prefix="/api", tags=["Users"])
app.include_router(courses_router, prefix="/api", tags=["Courses"])
app.include_router(course_content_router, prefix="/api", tags=["Courses Content"])
app.include_router(course_materials_router, prefix="/api", tags=["Course Materials"])
app.include_router(assignmentcontent_router, prefix="/api", tags=["Assignments Content"])
app.include_router(assignmentcreate_router, prefix="/api", tags=["Assignments Create"])
app.include_router(assignment_submissions_router, prefix="/api", tags=["Assignment Submissions"])
app.include_router(exams_router, prefix="/api", tags=["Exams"])
app.include_router(exam_submissions_router, prefix="/api", tags=["Exam Submissions"])
app.include_router(quizzes_router, prefix="/api", tags=["Quizzes"])
app.include_router(quiz_submissions_router, prefix="/api", tags=["Quiz Submissions"])
app.include_router(student_courses_router, prefix="/api", tags=["Student Courses"])
app.include_router(grades_router, prefix="/api", tags=["Grades"])
app.include_router(students_router, prefix="/api", tags=["Students"])
app.include_router(instructors_router, prefix="/api", tags=["Instructors"])
