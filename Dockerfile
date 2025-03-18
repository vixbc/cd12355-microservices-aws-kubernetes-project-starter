# Python 3.8 image base
FROM python:3.8-slim

# install system dependencies 
RUN apt-get update -y && \
    apt-get install -y --no-install-recommends \
    build-essential \
    libpq-dev \
    && rm -rf /var/lib/apt/lists/*

# upgrade pip, setuptools,  wheel
RUN pip install --upgrade pip setuptools wheel


# Set working directory
WORKDIR /app

# Copy only the requirements file first (for caching dependencies)
COPY analytics/requirements.txt /app/requirements.txt

# Install Python dependencies
RUN pip install --no-cache-dir -r /app/requirements.txt

# Copy the rest of the application code
COPY analytics /app/

# Set environment variables for the database connection
# These will be set dynamically at runtime
ENV DB_USERNAME=myuser
ENV DB_PASSWORD=mypassword
ENV DB_HOST=postgresql-service
ENV DB_PORT=5433
ENV DB_NAME=mydatabase

# Set the application port
ENV APP_PORT=5153

# Expose the port your app will run on
EXPOSE 5153

# Command to run the application
CMD ["python", "app.py"]
