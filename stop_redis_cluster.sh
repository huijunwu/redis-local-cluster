#!/bin/bash -ex

# This script stops and removes the Redis 6-node cluster and Redis Insight UI
# containers, networks, and volumes managed by Docker Compose.

# --- Prerequisites ---
# Before running this script:
# 1. Ensure Docker Desktop is running.
# 2. Make sure you are in the directory containing your 'docker-compose.yml' file.

echo "--- Stopping and Removing Redis 6-Node Cluster and Redis Insight (Docker Compose) ---"

# Step 1: Stop and remove all services, networks, and default volumes
# The '-v' flag also removes the anonymous volumes created for data persistence.
# For named volumes (like redis-data-X and redisinsight-data), it will remove them too
# if they are not explicitly marked as 'external' in docker-compose.yml.
echo "Stopping and removing Docker Compose services and associated resources..."
docker-compose down -v

# Check if docker-compose down was successful
if [ $? -eq 0 ]; then
    echo "All Redis cluster and Redis Insight services have been stopped and removed successfully."
    echo "Data persisted in named volumes (redis-data-X, redisinsight-data) has also been removed."
else
    echo "Failed to stop or remove Docker Compose services. Please check the error messages above."
    exit 1
fi

echo "--- Script finished. Your Redis cluster and Redis Insight are no longer running. ---"
