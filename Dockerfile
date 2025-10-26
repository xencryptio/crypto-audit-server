# -------------------------------
#   Dockerfile for Crypto Scanner
# -------------------------------

# Use a lightweight Python base image
FROM python:3.11-slim

# Set the working directory inside the container
WORKDIR /app

# --- Prepare requirements.txt and install dependencies ---
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# --- Copy all application code and folders ---
# This copies api_server.py, dashboard.html, Windows Agent/, and Linux Agent/
COPY . .

# --- FIX: Update hardcoded API URLs in files ---
# 1. Removes hardcoded http://nipunnegi:8000 from dashboard.html
# 2. Removes same URL from Linux Agent/crypto-agent.service
RUN sed -i 's|const API_HOST = "http://nipunnegi:8000"|const API_HOST = ""|g' dashboard.html && \
    sed -i 's|http://nipunnegi:8000||g' "Linux Agent/crypto-agent.service"

# Expose the port the FastAPI app runs on
EXPOSE 8000

# Command to run the application using python and uvicorn (as defined in api_server.py)
CMD ["python", "api_server.py"]
