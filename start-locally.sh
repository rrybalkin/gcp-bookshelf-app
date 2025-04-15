#!/usr/bin/env sh

python3 -m venv venv
source venv/bin/activate

source .env

cd ./source

pip3 install -r requirements.txt  # Install dependencies
export EXTERNAL_HOST_URL="http://localhost:8080"
export DAO_TYPE="cloudsql"

echo "GCP Project: ${GOOGLE_CLOUD_PROJECT}"

# to allow OAuth use insecure protocol http
export OAUTHLIB_INSECURE_TRANSPORT=1

# need to re-export to make visible for Python subprocess
export GOOGLE_CLOUD_PROJECT="$GOOGLE_CLOUD_PROJECT"
export GOOGLE_APPLICATION_CREDENTIALS="$GOOGLE_APPLICATION_CREDENTIALS"
export CLOUDSQL_HOST="$CLOUDSQL_HOST"
export CLOUDSQL_PORT="$CLOUDSQL_PORT"
export CLOUDSQL_DB_NAME="$CLOUDSQL_DB_NAME"
export CLOUDSQL_DB_USER="$CLOUDSQL_DB_USER"
export CLOUDSQL_DB_PASS="$CLOUDSQL_DB_PASS"

../venv/bin/gunicorn -b :8080 main:app

deactivate