"""Add imageUrl column to books table

Revision ID: 33176ce3cd22
Revises: 22cb339e2ab2
Create Date: 2025-04-15 22:21:12.955064

"""
from typing import Sequence, Union

from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision: str = '33176ce3cd22'
down_revision: Union[str, None] = '22cb339e2ab2'
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    """Upgrade schema."""
    op.add_column('books', sa.Column('image_url', sa.String(255)))


def downgrade() -> None:
    """Downgrade schema."""
    op.drop_column('books', 'image_url')
