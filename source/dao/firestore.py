from google.cloud import firestore

from dao.booksdb import BookDAO


class FirestoreBookDAO(BookDAO):
    """
    Firestore implementation of the BookDAO interface.
    """
    def __init__(self, logger):
        self.logger = logger
        self.logger.info("Establising connection to Firestore database")
        self.db = firestore.Client()

    @staticmethod
    def document_to_dict(doc):
        """
        Convert Firestore document to a Python dictionary.
        """
        if not doc.exists:
            return None
        doc_dict = doc.to_dict()
        doc_dict['id'] = doc.id
        return doc_dict

    def read(self, book_id):
        book_ref = self.db.collection("books").document(book_id)
        return self.document_to_dict(book_ref.get())

    def create(self, data):
        book_ref = self.db.collection("books").document()
        book_ref.set(data)
        return self.document_to_dict(book_ref.get())

    def update(self, book_id, data):
        book_ref = self.db.collection("books").document(book_id)
        book_ref.set(data)
        return self.document_to_dict(book_ref.get())

    def delete(self, book_id):
        book_ref = self.db.collection("books").document(book_id)
        book_ref.delete()

    def list(self):
        books = []
        docs = self.db.collection("books").order_by("title").stream()
        for doc in docs:
            books.append(self.document_to_dict(doc))
        return books
