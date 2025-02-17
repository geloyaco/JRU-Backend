# model/db.py
import mysql.connector

db_config = {
    "host": "localhost",
    "user": "root",
    "password": "",
    "database": "jru_system",
    "port": 3306,
}

def get_db():
    db = mysql.connector.connect(**db_config)
    cursor = db.cursor(dictionary=True)  # Returns results as dictionaries
    try:
        yield cursor, db  # Yield both cursor and connection
    finally:
        cursor.close()
        db.close()

