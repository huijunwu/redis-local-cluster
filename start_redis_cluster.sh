#!/bin/bash -ex

# This script starts the Redis 6-node cluster and Redis Insight UI using Docker Compose,
# then automatically opens the web UI in your default browser and displays the logs.

# --- Prerequisites ---
# Before running this script:
# 1. Ensure Docker Desktop is running.
# 2. Make sure you are in the directory containing your 'docker-compose.yml' file.
# 3. Ensure your 'redis.conf' file is located at the path specified in your 'docker-compose.yml'
#    (e.g., ~/redis.conf as per our previous discussion).

echo "--- Starting Redis 6-Node Cluster and Redis Insight (Docker Compose) ---"

# Step 1: Start Docker Compose services in detached mode
echo "Starting Docker Compose services..."
docker-compose up -d

# Check if docker-compose up was successful
if [ $? -eq 0 ]; then
    echo "Docker Compose services started successfully. Waiting for services to become ready..."
    # Give a brief moment for services to start before opening the browser
    sleep 5

    # Step 2: Open Redis Insight web UI in the default browser
    echo "Opening Redis Insight web UI in your default browser at http://localhost:8001"
    # Use platform-agnostic commands to open the URL
    if command -v xdg-open > /dev/null; then
        xdg-open http://localhost:8001 &
    elif command -v open > /dev/null; then
        open http://localhost:8001 &
    elif command -v start > /dev/null; then
        start http://localhost:8001 &
    else
        echo "Could not open browser automatically. Please open http://localhost:8001 manually."
    fi

    # Step 3: Stream Docker Compose logs
    echo "--- Streaming Docker Compose logs (Press Ctrl+C to stop logs and keep containers running) ---"
    docker-compose logs -f
else
    echo "Failed to start Docker Compose services. Please check the error messages above."
    exit 1
fi

echo "--- Script finished. Your Redis cluster and Redis Insight are running in the background. ---"
echo "To stop all services: navigate to this directory and run 'docker-compose down'"
