# Redfish Service Validator Docker Image
# DMTF Redfish Service Validator - validates Redfish service implementations

FROM python:3.11-slim

LABEL maintainer="DMTF" \
      description="Redfish Service Validator - validates Redfish service implementations against CSDL schemas" \
      version="2.5.1"

# Set working directory
WORKDIR /app

# Install system dependencies (minimal for the slim image)
RUN apt-get update && apt-get install -y --no-install-recommends \
    && rm -rf /var/lib/apt/lists/*

# Copy requirements first for better layer caching
COPY requirements.txt .

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy the application source code
COPY . .

# Install the package
RUN pip install --no-cache-dir -e .

# Create directory for output/logs
RUN mkdir -p /output

# Set default output directory
ENV RSV_OUTPUT_DIR=/output

# Default entry point - the CLI validator
ENTRYPOINT ["rf_service_validator"]

# Default command shows help
CMD ["--help"]
