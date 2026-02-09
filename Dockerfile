# Line 1 & 2 can be comments or empty
# Line 3: Corrected FROM instruction
FROM python:3.9-slim

# Set working directory
WORKDIR /app

# Install system dependencies
# NOTE: Removed musl-dev (which caused exit code 100)
# NOTE: Added build-essential and python3-dev
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    wget \
    build-essential \
    libffi-dev \
    ffmpeg \
    aria2 \
    python3-dev \
    gcc \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Copy your requirements and install python dependencies
COPY requirements.txt .
RUN pip3 install --no-cache-dir -r requirements.txt

# Copy the rest of the app
COPY . .

# Command to run the bot
CMD ["python3", "main.py"]
        
COPY . /app/
WORKDIR /app/
RUN pip3 install --no-cache-dir --upgrade pip \
    && pip3 install --no-cache-dir --upgrade -r requirements.txt \
    && python3 -m pip install -U yt-dlp
CMD gunicorn app:app & python3 main.py




