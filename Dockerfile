# Base: Python 3.11 slim
FROM python:3.11-slim

# Install Node.js (needed for gmgn-cli)
RUN apt-get update && apt-get install -y \
    curl \
    && curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get install -y nodejs \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install gmgn-cli globally
RUN npm install -g gmgn-cli@1.3.9

# Set working directory
WORKDIR /app

# Copy requirements and install Python deps
COPY aitrader/requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy app files
COPY aitrader/ .

# Create outputs directory (persisted via Railway volume)
RUN mkdir -p outputs

# Expose port
EXPOSE 8000

# Start FastAPI with 0.0.0.0 so Railway can reach it
CMD ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "8000"]
