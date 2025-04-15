from abc import ABC, abstractmethod


class BookDAO(ABC):
    """
    Abstract class defining the interface for Book Data Access Object (DAO).
    """

    @abstractmethod
    def read(self, book_id):
        pass

    @abstractmethod
    def create(self, data):
        pass

    @abstractmethod
    def update(self, book_id, data):
        pass

    @abstractmethod
    def delete(self, book_id):
        pass

    @abstractmethod
    def list(self):
        pass
