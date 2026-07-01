---
priority: P2
category: mongodb
---

# Connection Pooling Configuration

**Do**: Configure connection pool settings (`maxPoolSize`, `minPoolSize`) appropriate to your workload. Set `maxPoolSize` based on expected concurrent connections and MongoDB server `maxIncomingConnections` limits.

**Avoid**: Using default pool sizes or creating a new connection per request. Unbounded connection pools exhaust MongoDB server connections and degrade performance for all clients.

**Example**:
```yaml
# Application-side connection pool configuration
# (example for Node.js / MongoDB driver)
apiVersion: v1
kind: ConfigMap
metadata:
  name: mongodb-connection-config
data:
  MONGODB_MAX_POOL_SIZE: "50"
  MONGODB_MIN_POOL_SIZE: "10"
  MONGODB_MAX_IDLE_TIME_MS: "30000"
  MONGODB_WAIT_QUEUE_TIMEOUT_MS: "5000"
---
# MongoDB server-side connection limit
apiVersion: mongodbcommunity.mongodb.com/v1
kind: MongoDBCommunity
metadata:
  name: mongodb
spec:
  members: 3
  additionalMongodConfig:
    net:
      maxIncomingConnections: 500
```
