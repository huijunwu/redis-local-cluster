# **Local Redis Cluster (6-Node with Redis Commander UI)**

This repository provides a complete setup for running a highly available Redis Cluster locally using Docker Compose. The cluster consists of 6 nodes (3 masters and 3 replicas), designed for local development, testing, and learning about Redis Cluster functionalities. It includes a Python client example for interaction and integrates Redis Commander as a web-based GUI for easy data visualization and management.

## **Project Description**

This project offers a robust, containerized environment for a Redis Cluster. It simplifies the deployment of a distributed Redis setup, allowing developers to simulate a production-like Redis environment on their local machine without complex manual configurations. Key operations like starting, stopping, and interacting with the cluster are streamlined through simple bash scripts. Data can be manipulated via a Python client, and the entire cluster's state and data can be explored through a user-friendly web interface (Redis Commander).

## **Features**

* **6-Node Redis Cluster:** Configured with 3 master nodes and 3 replica nodes for high availability and data sharding.  
* **Dockerized Setup:** All Redis nodes and the web UI run in isolated Docker containers, managed by a single docker-compose.yml file.  
* **Redis** Commander Web **UI:** A web-based graphical interface for browsing data, executing commands, and monitoring the cluster.  
* **Python Client Integration:** Includes a Jupyter Notebook example (connect\_cluster.ipynb) demonstrating how to connect to and interact with the cluster programmatically using the redis-py library.  
* **Automated Lifecycle Scripts:** Easy-to-use bash scripts to start and stop the entire cluster stack.  
* **Persistent Data:** Configured with Docker volumes to ensure your Redis data persists across container restarts.  
* **Custom redis.conf:** Utilizes a custom Redis configuration file for fine-grained control over cluster settings.

## **Prerequisites**

Before you begin, ensure you have the following installed on your system:

* **Docker Desktop:** (Includes Docker Engine and Docker Compose)  
  * [Download Docker Desktop](https://www.docker.com/products/docker-desktop)  
* **Python 3.x** and pip (for the Python client example)  
* **Jupyter Notebook** (optional, for running connect\_cluster.ipynb)  
  pip install jupyter redis

## **File Structure**

.  
├── connect\_cluster.ipynb  
├── docker-compose.yml  
├── redis.conf  
├── start\_redis\_cluster.sh  
└── stop\_redis\_cluster.sh

## **Setup and Usage**

### **1\. Clone the Repository**

First, clone this GitHub repository to your local machine:  
git clone \[https://github.com/your-username/redis-local-cluster.git\](https://github.com/your-username/redis-local-cluster.git)  
cd redis-local-cluster

*(Replace* your-username with your actual *GitHub username or the repository's path)*

### **2\. Configure redis.conf**

Ensure the redis.conf file is accessible to Docker Compose and contains the necessary cluster settings. By default, the docker-compose.yml expects it in your user's home directory.  
**Create or verify \~/redis.conf (e.g., /home/youruser/redis.conf on Linux/macOS, C:\\Users\\youruser\\redis.conf on Windows):**  
\# \~/redis.conf  
port 6379  
cluster-enabled yes  
cluster-config-file nodes.conf  
cluster-node-timeout 5000  
appendonly yes  
protected-mode no  
bind 0.0.0.0  
loglevel notice

**Important:** The docker-compose.yml volume mount for redis.conf uses \~/redis.conf. You *must* replace \~ with the **absolute path** to your user's home directory in the docker-compose.yml if you haven't already. For example:  
    volumes:  
      \- /home/youruser/redis.conf:/opt/redis/redis.conf \# Linux example  
      \# \- /Users/youruser/redis.conf:/opt/redis/redis.conf \# macOS example  
      \# \- C:/Users/youruser/redis.conf:/opt/redis/redis.conf \# Windows example

### **3\. Start the Cluster and Web UI**

Use the provided start\_redis\_cluster.sh script to bring up all services. This script will:

* Start the 6 Redis nodes and the Redis Commander UI.  
* Automatically create the Redis cluster (3 masters, 3 replicas).  
* Open Redis Commander in your default web browser (http://localhost:8081).  
* Stream Docker logs for real-time monitoring.

chmod \+x start\_redis\_cluster.sh  
./start\_redis\_cluster.sh

Wait a few moments for all services to initialize. You should see "Cluster created successfully" in the logs.

### **4\. Access the Web UI (Redis Commander)**

Once the start\_redis\_cluster.sh script opens your browser to http://localhost:8081:

* Redis Commander should automatically detect and connect to your cluster.  
* On the left sidebar, you'll see your redis-cluster connection. Click on it.  
* In the main content area, navigate to the **"Keys"** or **"Browser"** tab.  
* To see all keys across the cluster, type \* (asterisk) in the search/filter bar and press Enter. This will perform a cluster-wide SCAN.

### **5\. Connect with the Python Client**

The connect\_cluster.ipynb Jupyter Notebook demonstrates how to programmatically interact with your cluster.  
jupyter notebook connect\_cluster.ipynb

Follow the instructions in the notebook to run the Python code. The Python client (redis-py) is cluster-aware and will handle routing commands to the correct nodes.

### **6\. Stop the Cluster**

To stop all running Docker containers and remove associated resources (including persistent data volumes for a clean slate), use the stop\_redis\_cluster.sh script:  
chmod \+x stop\_redis\_cluster.sh  
./stop\_redis\_cluster.sh

This script uses docker-compose down \-v to ensure a full cleanup.

## **Troubleshooting**

* **ERR\_CONNECTION\_RESET or UI not reachable for Redis Insight:** This project has switched to Redis Commander due to known compatibility issues with Redis Insight on certain Docker environments. Ensure you are using Redis Commander at http://localhost:8081.  
* **Got no slots in CLUSTER SLOTS / Cluster not forming:**  
  * This indicates the redis-cli \--cluster create command failed or ran too early.  
  * **Solution:** Always perform a full cleanup (./stop\_redis\_cluster.sh) before restarting with ./start\_redis\_cluster.sh. The docker-compose.yml has health checks and delays to make this more robust.  
  * Verify protected-mode no and bind 0.0.0.0 in your redis.conf.  
* **Python Client ConnectionError:**  
  * Ensure your Docker containers are fully up and the cluster is formed (cluster\_state:ok from docker exec redis-node-1 redis-cli cluster info).  
  * Verify the host ports in connect\_cluster.ipynb (10001, 10002, etc.) match your docker-compose.yml mappings.  
* **Data not appearing in Web UI:**  
  * **Crucial:** In Redis Commander (or any Redis cluster GUI), use the **\* (asterisk) wildcard in the search/filter bar** to trigger a full cluster scan and display all keys. Your data is sharded across multiple nodes.

## **License**

This project is open-source and available under the [MIT License](http://docs.google.com/LICENSE).