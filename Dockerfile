FROM python:3.12-slim

WORKDIR /app

COPY source .

RUN apt-get update && apt-get install -y \
    gcc \
    libpq-dev && \
    pip install --upgrade pip && \
    pip install -r requirements.txt

EXPOSE $PORT

# Allow statements and log messages to immediately appear in the logs
ENV PYTHONUNBUFFERED True

# Run the Flask application
# Run the web service on container startup. Here we use the gunicorn
# webserver, with one worker process and 8 threads.
# For environments with multiple CPU cores, increase the number of workers
# to be equal to the cores available.
# Timeout is set to 0 to disable the timeouts of the workers to allow Cloud Run to handle instance scaling.
CMD gunicorn --bind :$PORT --workers 1 --threads 8 --timeout 0 main:app
