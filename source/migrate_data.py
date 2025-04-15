
from dao.firestore import FirestoreBookDAO
from dao.cloudsql import CloudSQLBookDAO


def migrate_data(logger):
    """
    Migrate data from Firestore to CloudSQL.
    """
    print("Starting data migration from Firestore to CloudSQL...")

    # Initialize DAOs
    firestore_dao = FirestoreBookDAO(logger)
    cloudsql_dao = CloudSQLBookDAO(logger)

    # Retrieve all books from Firestore
    firestore_books = firestore_dao.list()
    print(f"Retrieved {len(firestore_books)} book(s) from Firestore.")

    # Insert data into CloudSQL
    for book in firestore_books:
        # Prepare data for CloudSQL (Firestore documents may have additional fields like `id`)
        book_data = {
            "title": book.get("title"),
            "author": book.get("author"),
            "published_date": book.get("published_date"),
            "description": book.get("description"),
        }
        # Insert into CloudSQL
        cloudsql_dao.create(book_data)
        print(f"Migrated book: {book_data['title']}")

    print("Data migration completed successfully.")
