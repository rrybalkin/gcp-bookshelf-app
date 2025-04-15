"""create books table

Revision ID: 22cb339e2ab2
Revises: 
Create Date: 2025-04-15 16:27:24.705159

"""
from typing import Sequence, Union

from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision: str = '22cb339e2ab2'
down_revision: Union[str, None] = None
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade():
    """Upgrade schema."""
    op.create_table(
        'books',
        sa.Column('id', sa.Integer, autoincrement=True, primary_key=True),
        sa.Column('title', sa.String(255), nullable=False),
        sa.Column('author', sa.String(50)),
        sa.Column('published_date', sa.String(30)),
        sa.Column('description', sa.Unicode(2000)),
    )


def downgrade():
    """Downgrade schema."""
    op.drop_table('books')
