# Use Python 3.9 base image based on Alpine Linux
FROM python:3.9-alpine3.13

# Maintainer information
LABEL maintainer="itqonibras.vercel.app"

# Disable Python output buffering (useful for logs in containers)
ENV PYTHONUNBUFFERED=1

# Copy the requirements file into a temporary directory in the container
COPY ./requirements.txt /tmp/requirements.txt
COPY ./requirements.dev.txt /tmp/requirements.dev.txt

# Copy the application code into the container
COPY ./app /app

# Set the working directory
WORKDIR /app

# Expose port 8000 (commonly used by Django/uvicorn)
EXPOSE 8000

# Create a virtual environment, install dependencies, and clean up
ARG DEV=false
RUN python -m venv /py && \
    /py/bin/pip install --upgrade pip && \
    apk add --update --no-cache postgresql-client && \
    apk add --update --no-cache --virtual .tmp-build-deps \
    build-base postgresql-dev musl-dev && \
    /py/bin/pip install -r /tmp/requirements.txt && \
    if [ $DEV = "true" ]; \
    then /py/bin/pip install -r /tmp/requirements.dev.txt ; \
    fi && \
    rm -rf /tmp && \
    apk del .tmp-build-deps && \
    adduser \
    --disabled-password \
    --no-create-home \
    django-user

# Add the virtual environment to the system PATH
ENV PATH="/py/bin:$PATH"

# Switch to non-root user for security
USER django-user
