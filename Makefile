.PHONY: up down reset logs ps ui-hadoop ui-yarn ui-hive ui-jupyter setup-hdfs

# Start all services
up:
	docker-compose up -d
	@echo "Waiting for services to be healthy..."
	@powershell -Command "Start-Sleep -Seconds 30"
	docker exec -u root spark-jupyter bash -c "apt-get update && apt-get install -y docker.io && chmod 666 /var/run/docker.sock"
	@make setup-hdfs

# Stop all services
down:
	docker-compose down

# Stop and remove all volumes (FULL RESET)
reset:
	docker-compose down -v
	@echo "All containers and volumes removed."

# View logs
logs:
	docker-compose logs -f

# Check status
ps:
	docker-compose ps

# Setup HDFS directories
setup-hdfs:
	@echo "Creating HDFS directories..."
	docker exec hadoop-namenode hdfs dfs -mkdir -p /user/spark
	docker exec hadoop-namenode hdfs dfs -mkdir -p /user/hive/warehouse
	docker exec hadoop-namenode hdfs dfs -mkdir -p /data/raw
	docker exec hadoop-namenode hdfs dfs -chmod g+w /user/hive/warehouse
	@echo "HDFS directories created."

# Open Web UIs
ui-hadoop:
	open http://localhost:9870 || xdg-open http://localhost:9870

ui-yarn:
	open http://localhost:8088 || xdg-open http://localhost:8088

ui-hive:
	open http://localhost:10002 || xdg-open http://localhost:10002

ui-jupyter:
	open http://localhost:8888 || xdg-open http://localhost:8888

# Download PostgreSQL JDBC jar
download-jars:
	mkdir -p jars
	curl -L https://jdbc.postgresql.org/download/postgresql-42.7.3.jar -o jars/postgresql-42.7.3.jar
	@echo "PostgreSQL JDBC jar downloaded."
