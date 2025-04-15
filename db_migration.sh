
source venv/bin/activate

source .env

echo "Running DB migration..."
echo "Please, make sure CloudSQL Auth Proxy is running locally and serving connection on ${CLOUDSQL_HOST}:${CLOUDSQL_PORT}"

export DB_URL="postgresql://${CLOUDSQL_DB_USER}:${CLOUDSQL_DB_PASS}@${CLOUDSQL_HOST}:${CLOUDSQL_PORT}/${CLOUDSQL_DB_NAME}"
alembic upgrade head && echo "INFO: Migration succeed." || echo "ERROR: Migration failed, check logs."

deactivate
