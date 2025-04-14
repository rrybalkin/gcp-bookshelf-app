#!/usr/bin/env sh

python3 -m venv venv
source venv/bin/activate

cd ./source
pip3 install -r requirements.txt  # Install dependencies
export EXTERNAL_HOST_URL="http://localhost:8080"
export GOOGLE_CLOUD_PROJECT="cloudx-gcp-developer-rrybalkin"
export GOOGLE_APPLICATION_CREDENTIALS="/Users/Roman_Rybalkin/.config/gcloud/application_default_credentials.json"
../venv/bin/gunicorn -b :8080 main:app

deactivate