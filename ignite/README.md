# Apache Ignite Docker Setup

High-performance in-memory computing platform for distributed caching, computing, and real-time processing.

## Features

- Official Docker image: `apacheignite/ignite:latest`
- In-memory data grid
- Distributed SQL database
- Distributed computing
- Persistence enabled
- REST API enabled

## Quick Start

```bash
# Start Apache Ignite
docker compose up -d

# View logs
docker compose logs -f

# Stop Apache Ignite
docker compose down
```

## Ports

- **10800**: Thin client port (JDBC, ODBC, .NET, C++, Python, Node.js clients)
- **11211**: REST API port
- **47100**: Discovery port (cluster communication)
- **47500**: Communication port (data exchange)

## Configuration

### Memory Settings

Edit JVM options in `compose.yml`:

```yaml
environment:
  - JVM_OPTS=-Xms1g -Xmx1g  # Set initial and maximum heap to 1GB
```

### Enable Additional Libraries

```yaml
environment:
  - OPTION_LIBS=ignite-rest-http,ignite-spring,ignite-indexing
```

Available libraries:
- `ignite-rest-http` - REST API
- `ignite-spring` - Spring integration
- `ignite-indexing` - SQL queries
- `ignite-ml` - Machine Learning
- `ignite-kubernetes` - Kubernetes discovery

## Using REST API

```bash
# Get cluster state
curl http://localhost:11211/ignite?cmd=version

# Create cache
curl "http://localhost:11211/ignite?cmd=getorcreate&cacheName=myCache"

# Put value
curl "http://localhost:11211/ignite?cmd=put&key=1&val=hello&cacheName=myCache"

# Get value
curl "http://localhost:11211/ignite?cmd=get&key=1&cacheName=myCache"
```

## Using SQL

Connect to SQL line:

```bash
make sqlline
# or
docker compose exec ignite /opt/ignite/apache-ignite/bin/sqlline.sh -u jdbc:ignite:thin://127.0.0.1
```

Example SQL commands:

```sql
-- Create table
CREATE TABLE City (id LONG PRIMARY KEY, name VARCHAR) WITH "template=replicated";

-- Insert data
INSERT INTO City (id, name) VALUES (1, 'Seoul');
INSERT INTO City (id, name) VALUES (2, 'Busan');

-- Query data
SELECT * FROM City;
```

## Persistence

Data is stored in two volumes:
- `ignite-persistence`: Persistent data storage
- `ignite-work`: Working directory

To backup:

```bash
docker run --rm -v ignite-persistence:/source -v $(pwd):/backup alpine tar czf /backup/ignite-backup.tar.gz -C /source .
```

## Clustering

To create a cluster, add more nodes:

```yaml
services:
  ignite-node1:
    image: apacheignite/ignite:latest
    networks:
      - ignite-network

  ignite-node2:
    image: apacheignite/ignite:latest
    networks:
      - ignite-network
```

Nodes will auto-discover each other on the same network.

## Official Documentation

- Docker Hub: https://hub.docker.com/r/apacheignite/ignite
- Apache Ignite: https://ignite.apache.org/
- Docker Deployment Guide: https://apacheignite.readme.io/docs/docker-deployment
- Installing Using Docker: https://ignite.apache.org/docs/latest/installation/installing-using-docker
