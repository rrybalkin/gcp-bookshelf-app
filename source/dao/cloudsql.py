import os
import secrets

import psycopg2
from psycopg2.extras import RealDictCursor

from dao.booksdb import BookDAO


class CloudSQLBookDAO(BookDAO):
    """
    CloudSQL implementation of the BookDAO interface.
    """
    def __init__(self, logger):
        self.logger = logger
        self.connection_info = {
            "host": os.getenv('CLOUDSQL_HOST', 'localhost'),
            "port": os.getenv('CLOUDSQL_PORT', '5432'),
            "dbname": os.getenv('CLOUDSQL_DB_NAME', 'app_database'),
            "user": secrets.get_secret('cloudsql-db-user'),
            "password": secrets.get_secret('cloudsql-db-pass'),
        }

    def connect_db(self):
        """Establish database connection."""
        self.logger.info("Establising connection to CloudSQL database[{0}] by URL={1} for user={2}"
                         .format(self.connection_info['dbname'], self.connection_info['host'], self.connection_info['user']))
        conn = psycopg2.connect(**self.connection_info)
        self.logger.info("Connection succesfully established!")
        return conn

    @staticmethod
    def book_to_dict(record):
        """Convert a database record (row) to a Python dictionary."""
        if not record:
            return None
        record['imageUrl'] = record['image_url']
        record['publishedDate'] = record['published_date']
        return record

    def read(self, book_id):
        conn = self.connect_db()
        try:
            with conn.cursor(cursor_factory=RealDictCursor) as cursor:
                cursor.execute("SELECT * FROM books WHERE id = %s;", (book_id,))
                record = cursor.fetchone()
                return self.book_to_dict(record)
        finally:
            conn.close()

    def create(self, data):
        conn = self.connect_db()
        try:
            with conn.cursor(cursor_factory=RealDictCursor) as cursor:
                cursor.execute(
                    "INSERT INTO books (title, author, image_url, published_date, description) VALUES (%s, %s, %s, %s, %s) RETURNING *;",
                    (data.get("title"), data.get("author"), data.get("imageUrl"), data.get("publishedDate"), data.get("description"))
                )
                record = cursor.fetchone()
                conn.commit()
                return self.book_to_dict(record)
        finally:
            conn.close()

    def update(self, book_id, data):
        conn = self.connect_db()
        try:
            with conn.cursor(cursor_factory=RealDictCursor) as cursor:
                cursor.execute(
                    "UPDATE books SET title = %s, author = %s, image_url = %s, published_date = %s, description = %s WHERE id = %s RETURNING *;",
                    (data.get("title"), data.get("author"), data.get("imageUrl"), data.get("publishedDate"), data.get("description"), book_id)
                )
                record = cursor.fetchone()
                conn.commit()
                return self.book_to_dict(record)
        finally:
            conn.close()

    def delete(self, book_id):
        conn = self.connect_db()
        try:
            with conn.cursor() as cursor:
                cursor.execute("DELETE FROM books WHERE id = %s;", (book_id,))
                conn.commit()
        finally:
            conn.close()

    def list(self):
        conn = self.connect_db()
        try:
            with conn.cursor(cursor_factory=RealDictCursor) as cursor:
                cursor.execute("SELECT * FROM books ORDER BY title ASC;")
                records = cursor.fetchall()
                return [self.book_to_dict(record) for record in records]
        finally:
            conn.close()
