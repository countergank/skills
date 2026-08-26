---
priority: P0
category: mongodb
---

# Enable MongoDB Authentication

**Do**: Enable authentication by setting `--auth` or using environment variables (`MONGO_INITDB_ROOT_USERNAME`, `MONGO_INITDB_ROOT_PASSWORD`) to require credentials for all connections.

**Avoid**: Running MongoDB without authentication, which exposes all databases to unauthenticated access and is a common source of data breaches.

**Example**:
```yaml
containers:
  - name: mongod
    image: mongo:7.0
    args:
      - --auth
    env:
      - name: MONGO_INITDB_ROOT_USERNAME
        valueFrom:
          secretKeyRef:
            name: mongodb-credentials
            key: username
      - name: MONGO_INITDB_ROOT_PASSWORD
        valueFrom:
          secretKeyRef:
            name: mongodb-credentials
            key: password
```
