# Base image
FROM python:3.11-slim

# Set working directory
WORKDIR /app

# Copy requirements, means copying the requirements.txt file from the host machine to the current working directory in the container 
COPY requirements.txt .

# Install dependencies 
RUN pip install --no-cache-dir -r requirements.txt
# --no-cache-dir  this keeps the image size smaller by not caching the installed packages

# Copy application code
COPY app ./app

# Expose port, means container listens on this port for incoming requests, in this case, it's the default port for FastAPI applications
EXPOSE 8000

# Start FastAPI server, means uvicorn app.main:app --host 0.0.0.0 --port 8000
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]
# uvicorn the asgi server to start fastapi application