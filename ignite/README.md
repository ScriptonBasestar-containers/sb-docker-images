# Apache Ignite

Apache Ignite is a distributed database for high-performance computing with in-memory speed. It provides
a unified API for SQL, key-value, compute, and machine learning workloads.

## Overview

This directory provides a standalone Apache Ignite instance for development and testing purposes.

**Key Features:**
- ✅ In-memory distributed database
- ✅ SQL and key-value support
- ✅ ACID transactions
- ✅ Data persistence enabled
- ✅ REST API included
- ✅ Thin client support
- ✅ Horizontal scalability

---

## Quick Start

```bash
cd ignite

# Start Ignite
docker compose up -d

# Check status
docker compose ps

# View logs
docker compose logs -f

# Stop Ignite
docker compose down
```

**Access REST API:**
```bash
# Check cluster status
curl http://localhost:11211/ignite?cmd=version
```

---

## Configuration

### Default Settings

| Setting | Value | Description |
|---------|-------|-------------|
| **Thin Client Port** | 10800 | JDBC/ODBC thin client connections |
| **REST API Port** | 11211 | HTTP REST API |
| **Discovery Port** | 47100 | Node discovery (cluster) |
| **Communication Port** | 47500 | Inter-node communication |
| **Container** | ignite | Container name |
| **Image** | apacheignite/ignite:latest | Official Apache Ignite |
| **JVM Heap** | 512MB (min/max) | Java memory allocation |

### Environment Variables

Copy `.env.example` to `.env` to customize:

```bash
cp .env.example .env
```

**.env variables:**
```bash
IGNITE_THIN_CLIENT_PORT=10800
IGNITE_REST_PORT=11211
IGNITE_DISCOVERY_PORT=47100
IGNITE_COMMUNICATION_PORT=47500
JVM_OPTS=-Xms512m -Xmx512m
IGNITE_WORK_DIR=/persistence
OPTION_LIBS=ignite-rest-http
```

### Memory Sizing

| Use Case | JVM Heap Size |
|----------|---------------|
| **Development** | `-Xms512m -Xmx512m` |
| **Small production** | `-Xms1g -Xmx2g` |
| **Medium production** | `-Xms2g -Xmx4g` |
| **Large production** | `-Xms4g -Xmx8g` |

Update `JVM_OPTS` in `.env` or `compose.yml`:
```yaml
environment:
  - JVM_OPTS=-Xms2g -Xmx4g
```

---

## Connecting to Ignite

### From Docker Containers (Same Network)

```yaml
services:
  your-app:
    environment:
      IGNITE_HOST: ignite
      IGNITE_PORT: 10800
    networks:
      - ignite-network

networks:
  ignite-network:
    external: true
    name: ignite_ignite-network
```

### From Host Machine

**Thin Client URL:**
```
ignite://localhost:10800
```

**REST API:**
```
http://localhost:11211/ignite
```

### From Application Code

**Java (Thin Client):**
```java
import org.apache.ignite.client.IgniteClient;
import org.apache.ignite.configuration.ClientConfiguration;

ClientConfiguration cfg = new ClientConfiguration()
    .setAddresses("localhost:10800");  // or "ignite:10800"

try (IgniteClient client = Ignite.startClient(cfg)) {
    ClientCache<Integer, String> cache = client.getOrCreateCache("myCache");

    // Put data
    cache.put(1, "Hello Ignite");

    // Get data
    String value = cache.get(1);
    System.out.println(value);
}
```

**Python (pyignite):**
```python
from pyignite import Client

client = Client()
client.connect('localhost', 10800)  # or 'ignite' if in same network

# Create cache
cache = client.create_cache('myCache')

# Put data
cache.put(1, 'Hello Ignite')

# Get data
value = cache.get(1)
print(value)  # Output: Hello Ignite

# Close connection
client.close()
```

**Node.js (apache-ignite-client):**
```javascript
const IgniteClient = require('apache-ignite-client');
const IgniteClientConfiguration = IgniteClient.IgniteClientConfiguration;

const igniteClient = new IgniteClient();

async function run() {
    try {
        // Connect
        await igniteClient.connect(new IgniteClientConfiguration('localhost:10800'));

        // Get or create cache
        const cache = await igniteClient.getOrCreateCache('myCache');

        // Put data
        await cache.put(1, 'Hello Ignite');

        // Get data
        const value = await cache.get(1);
        console.log(value);

        // Disconnect
        await igniteClient.disconnect();
    } catch (err) {
        console.error(err);
    }
}

run();
```

**C# (.NET):**
```csharp
using Apache.Ignite.Core;
using Apache.Ignite.Core.Client;
using Apache.Ignite.Core.Client.Cache;

var cfg = new IgniteClientConfiguration
{
    Endpoints = new[] { "localhost:10800" }  // or "ignite:10800"
};

using (var client = Ignition.StartClient(cfg))
{
    var cache = client.GetOrCreateCache<int, string>("myCache");

    // Put data
    cache.Put(1, "Hello Ignite");

    // Get data
    var value = cache.Get(1);
    Console.WriteLine(value);
}
```

---

## REST API Usage

### Basic Operations

**Get version:**
```bash
curl "http://localhost:11211/ignite?cmd=version"
```

**Create cache:**
```bash
curl "http://localhost:11211/ignite?cmd=getorcreate&cacheName=myCache"
```

**Put value:**
```bash
curl "http://localhost:11211/ignite?cmd=put&key=1&val=Hello&cacheName=myCache"
```

**Get value:**
```bash
curl "http://localhost:11211/ignite?cmd=get&key=1&cacheName=myCache"
```

**Execute SQL:**
```bash
curl "http://localhost:11211/ignite?cmd=qryfldexe&pageSize=10&cacheName=myCache&qry=SELECT+*+FROM+MyTable"
```

**Cluster topology:**
```bash
curl "http://localhost:11211/ignite?cmd=top&attr=true&mtr=true"
```

---

## SQL Operations

### JDBC Connection

**JDBC URL:**
```
jdbc:ignite:thin://localhost:10800
```

**Java example:**
```java
Class.forName("org.apache.ignite.IgniteJdbcThinDriver");
Connection conn = DriverManager.getConnection("jdbc:ignite:thin://localhost:10800");

// Create table
Statement stmt = conn.createStatement();
stmt.execute("CREATE TABLE Person (id INT PRIMARY KEY, name VARCHAR)");

// Insert data
stmt.execute("INSERT INTO Person (id, name) VALUES (1, 'John Doe')");

// Query data
ResultSet rs = stmt.executeQuery("SELECT * FROM Person");
while (rs.next()) {
    System.out.println(rs.getInt("id") + ": " + rs.getString("name"));
}

conn.close();
```

### SQL via Thin Client

**Python example:**
```python
from pyignite import Client
from pyignite.datatypes.cache_config import CacheMode

client = Client()
client.connect('localhost', 10800)

# Execute SQL
client.sql('''
    CREATE TABLE IF NOT EXISTS Person (
        id INT PRIMARY KEY,
        name VARCHAR
    ) WITH "cache_name=PersonCache"
''')

# Insert data
client.sql("INSERT INTO Person (id, name) VALUES (?, ?)", query_args=[1, 'John Doe'])

# Query data
result = client.sql("SELECT * FROM Person")
for row in result:
    print(row)

client.close()
```

---

## Cache Operations

### Cache Modes

Apache Ignite supports three cache modes:

| Mode | Description | Use Case |
|------|-------------|----------|
| **PARTITIONED** | Data distributed across nodes | Large datasets, scalability |
| **REPLICATED** | Full copy on each node | Read-heavy, small datasets |
| **LOCAL** | Single node only | Testing, temporary data |

### Creating Caches

**Via REST API:**
```bash
curl "http://localhost:11211/ignite?cmd=getorcreate&cacheName=myCache&cacheMode=PARTITIONED"
```

**Via thin client (Python):**
```python
from pyignite import Client
from pyignite.datatypes.cache_config import CacheMode

client = Client()
client.connect('localhost', 10800)

cache = client.create_cache({
    'name': 'myCache',
    'cache_mode': CacheMode.PARTITIONED,
    'backups': 1  # Number of backups
})

client.close()
```

---

## Monitoring and Maintenance

### Cluster Information

**Check cluster state:**
```bash
curl "http://localhost:11211/ignite?cmd=top"
```

**Node metrics:**
```bash
curl "http://localhost:11211/ignite?cmd=top&mtr=true"
```

**Cache statistics:**
```bash
curl "http://localhost:11211/ignite?cmd=cache&cacheName=myCache"
```

### Logs

```bash
# View real-time logs
docker compose logs -f ignite

# Check for errors
docker compose logs ignite | grep ERROR

# View last 100 lines
docker compose logs --tail 100 ignite
```

### Performance Metrics

**Using REST API:**
```bash
# Get node metrics
curl "http://localhost:11211/ignite?cmd=top&mtr=true" | jq '.response[0].metrics'
```

**Key metrics to monitor:**
- `heapMemoryUsed` / `heapMemoryMaximum` - Memory usage
- `averageCpuLoad` - CPU utilization
- `currentThreadCount` - Thread count
- `currentDaemonThreadCount` - Daemon threads

---

## Data Persistence

### Persistence Configuration

Apache Ignite supports native persistence for data durability:

**Check persistence status:**
```bash
docker volume ls | grep ignite
```

**Volumes:**
- `ignite-persistence`: Persistent data storage
- `ignite-work`: Work directory

### Backup and Restore

**Backup persistence volume:**
```bash
# Stop Ignite
docker compose down

# Backup volume
docker run --rm \
  -v ignite_ignite-persistence:/data \
  -v $(pwd):/backup \
  alpine tar czf /backup/ignite-backup-$(date +%Y%m%d).tar.gz /data

# Start Ignite
docker compose up -d
```

**Restore from backup:**
```bash
# Stop Ignite
docker compose down

# Remove old volume
docker volume rm ignite_ignite-persistence

# Restore
docker run --rm \
  -v ignite_ignite-persistence:/data \
  -v $(pwd):/backup \
  alpine sh -c "cd /data && tar xzf /backup/ignite-backup-YYYYMMDD.tar.gz --strip 1"

# Start Ignite
docker compose up -d
```

### Snapshot Management

**Create snapshot (via thin client):**
```python
from pyignite import Client

client = Client()
client.connect('localhost', 10800)

# Create snapshot
client.create_snapshot('snapshot_20250121')

client.close()
```

---

## Security Best Practices

### Production Deployment Checklist

- [ ] **Enable authentication**: Configure username/password
  ```xml
  <property name="authenticationEnabled" value="true"/>
  ```

- [ ] **Enable SSL/TLS**: Encrypt client-server communication
  ```xml
  <property name="sslContextFactory">
      <bean class="org.apache.ignite.ssl.SslContextFactory">
          <property name="keyStoreFilePath" value="keystore.jks"/>
          <property name="keyStorePassword" value="changeit"/>
      </bean>
  </property>
  ```

- [ ] **Restrict network access**: Use firewall rules

- [ ] **Increase JVM heap**: Set appropriate memory for production
  ```bash
  JVM_OPTS=-Xms4g -Xmx8g
  ```

- [ ] **Enable persistence**: For data durability

- [ ] **Configure backups**: Regular snapshots

- [ ] **Monitor metrics**: Track performance and health

- [ ] **Review security docs**: https://ignite.apache.org/docs/latest/security/

---

## Troubleshooting

### Connection Refused

**Symptom:** `Failed to connect to Ignite cluster`

**Solutions:**
1. Check if Ignite is running:
   ```bash
   docker compose ps
   ```

2. Verify thin client port:
   ```bash
   docker compose port ignite 10800
   ```

3. Check logs for errors:
   ```bash
   docker compose logs ignite | grep ERROR
   ```

### Out of Memory

**Symptom:** `java.lang.OutOfMemoryError: Java heap space`

**Solutions:**
1. Increase JVM heap size:
   ```yaml
   environment:
     - JVM_OPTS=-Xms2g -Xmx4g
   ```

2. Enable off-heap memory:
   ```xml
   <property name="dataRegionConfigurations">
       <list>
           <bean class="org.apache.ignite.configuration.DataRegionConfiguration">
               <property name="name" value="myDataRegion"/>
               <property name="maxSize" value="#{5L * 1024 * 1024 * 1024}"/>
           </bean>
       </list>
   </property>
   ```

### Slow Performance

**Symptom:** Queries or operations taking too long

**Causes:**
1. **Insufficient memory**: Increase JVM heap
2. **No indexes**: Create SQL indexes
3. **No backups**: Enable cache backups for fault tolerance
4. **Network issues**: Check inter-node communication

**Solutions:**
```sql
-- Create index for better performance
CREATE INDEX idx_person_name ON Person(name);

-- Use EXPLAIN to analyze query performance
EXPLAIN SELECT * FROM Person WHERE name = 'John';
```

### Node Discovery Issues

**Symptom:** Nodes not discovering each other in cluster

**Solution:**
Ensure discovery port (47100) is accessible:
```bash
# Check if port is listening
docker compose exec ignite netstat -tuln | grep 47100
```

---

## Use Cases

### 1. Distributed Cache

High-performance caching layer for applications:

```python
from pyignite import Client

client = Client()
client.connect('ignite', 10800)

cache = client.get_or_create_cache('sessionCache')

# Store session data
cache.put(session_id, session_data)

# Retrieve session
session = cache.get(session_id)

client.close()
```

### 2. In-Memory Database

SQL database with in-memory speed:

```java
try (IgniteClient client = Ignition.startClient(cfg)) {
    // Create table
    client.query(new SqlFieldsQuery(
        "CREATE TABLE Product (id INT PRIMARY KEY, name VARCHAR, price DECIMAL)"
    )).getAll();

    // Insert data
    client.query(new SqlFieldsQuery(
        "INSERT INTO Product (id, name, price) VALUES (?, ?, ?)"
    ).setArgs(1, "Laptop", 999.99)).getAll();

    // Query data
    List<List<?>> results = client.query(new SqlFieldsQuery(
        "SELECT * FROM Product WHERE price > 500"
    )).getAll();
}
```

### 3. Compute Grid

Distributed computations:

```java
try (Ignite ignite = Ignition.start()) {
    IgniteCompute compute = ignite.compute();

    // Execute computation on cluster
    Integer result = compute.call(() -> {
        // Computation logic
        return expensiveCalculation();
    });
}
```

### 4. Stream Processing

Real-time data processing:

```java
try (Ignite ignite = Ignition.start()) {
    IgniteDataStreamer<Integer, String> streamer =
        ignite.dataStreamer("myCache");

    // Stream data into cache
    for (int i = 0; i < 1000000; i++) {
        streamer.addData(i, "Value" + i);
    }

    streamer.close();
}
```

---

## Clustering

### Multi-Node Setup

For production, deploy multiple Ignite nodes:

**docker-compose-cluster.yml:**
```yaml
services:
  ignite-1:
    image: apacheignite/ignite:latest
    environment:
      - IGNITE_QUIET=false
      - JVM_OPTS=-Xms1g -Xmx1g
    networks:
      - ignite-cluster

  ignite-2:
    image: apacheignite/ignite:latest
    environment:
      - IGNITE_QUIET=false
      - JVM_OPTS=-Xms1g -Xmx1g
    networks:
      - ignite-cluster

  ignite-3:
    image: apacheignite/ignite:latest
    environment:
      - IGNITE_QUIET=false
      - JVM_OPTS=-Xms1g -Xmx1g
    networks:
      - ignite-cluster

networks:
  ignite-cluster:
    driver: bridge
```

**Start cluster:**
```bash
docker compose -f docker-compose-cluster.yml up -d
```

---

## Advanced Configuration

### Custom Configuration File

Create custom XML configuration:

**default-config.xml:**
```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xsi:schemaLocation="http://www.springframework.org/schema/beans
                           http://www.springframework.org/schema/beans/spring-beans.xsd">

    <bean class="org.apache.ignite.configuration.IgniteConfiguration">
        <!-- Configure data regions -->
        <property name="dataStorageConfiguration">
            <bean class="org.apache.ignite.configuration.DataStorageConfiguration">
                <property name="defaultDataRegionConfiguration">
                    <bean class="org.apache.ignite.configuration.DataRegionConfiguration">
                        <property name="persistenceEnabled" value="true"/>
                        <property name="maxSize" value="#{2L * 1024 * 1024 * 1024}"/>
                    </bean>
                </property>
            </bean>
        </property>
    </bean>
</beans>
```

**Mount configuration:**
```yaml
volumes:
  - ./default-config.xml:/opt/ignite/apache-ignite/config/default-config.xml
```

---

## Integration with Buildbox

**Note:** Apache Ignite is not included in Buildbox templates. However, you can use this standalone configuration
alongside Buildbox services for advanced use cases requiring distributed computing and in-memory data grids.

### Running with Buildbox Services

**Start Ignite (from this directory):**
```bash
cd ignite
docker compose up -d
# Ignite available at:
# - REST API: localhost:8080
# - SQL: localhost:10800
# - Thin Client: localhost:10800
```

**Start Buildbox services (from buildbox directory):**
```bash
cd ../buildbox
make postgres  # For persistent data storage
make redis     # For complementary caching
```

### Use Cases with Buildbox

**1. Ignite as Compute Grid + Buildbox as Data Source:**
```yaml
services:
  compute-app:
    environment:
      IGNITE_HOST: ignite
      POSTGRES_URL: postgresql://postgres:passw0rd@postgres_dev:5432/app_db
    networks:
      - ignite_compute-network
      - buildbox_data-network
```

**2. Hybrid Architecture:**
- **Ignite**: Hot data, real-time analytics, compute tasks
- **PostgreSQL** (Buildbox): Persistent storage, reporting
- **Redis** (Buildbox): Session storage, simple caching

```yaml
networks:
  ignite_compute-network:
    external: true
  buildbox_data-network:
    external: true
```

**See also:**
- [Buildbox README](../buildbox/README.md) for PostgreSQL/Redis templates
- [Redis README](../redis/README.md) for simple caching use cases

---

## References

### Official Documentation
- [Apache Ignite Official Site](https://ignite.apache.org/)
- [Documentation](https://ignite.apache.org/docs/latest/)
- [Quick Start Guide](https://ignite.apache.org/docs/latest/quick-start/java)
- [SQL Reference](https://ignite.apache.org/docs/latest/SQL/sql-introduction)
- [Docker Hub](https://hub.docker.com/r/apacheignite/ignite)
- [Security](https://ignite.apache.org/docs/latest/security/)

### Client Libraries
- Java: [Apache Ignite Core](https://ignite.apache.org/docs/latest/quick-start/java)
- Python: [pyignite](https://github.com/apache/ignite-python-thin-client)
- Node.js: [apache-ignite-client](https://www.npmjs.com/package/apache-ignite-client)
- .NET: [Apache.Ignite](https://www.nuget.org/packages/Apache.Ignite/)
- C++: [C++ Thin Client](https://ignite.apache.org/docs/latest/thin-clients/cpp-thin-client)

### Tools
- [Ignite Web Console](https://console.gridgain.com/) - Web management interface
- [IgniteUI](https://github.com/junphine/ignite-admin) - Admin UI
- [Apache Ignite Extensions](https://github.com/apache/ignite-extensions) - Additional modules

---

## License

This Docker Compose configuration is provided for development and testing purposes.
Apache Ignite is released under the [Apache License 2.0](https://www.apache.org/licenses/LICENSE-2.0).
