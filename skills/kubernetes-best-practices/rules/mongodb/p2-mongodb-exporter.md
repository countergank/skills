---
priority: P2
category: mongodb
---

# Add MongoDB Exporter Sidecar for Prometheus Metrics

**Do**: Add a `mongodb-exporter` sidecar container (percona/mongodb_exporter) to MongoDB StatefulSets for Prometheus-format metrics on port 9216.

**Avoid**: Running MongoDB without any metrics export — database health, query performance, and connection pool stats remain invisible to monitoring.

**Example**:
```yaml
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: mongodb
spec:
  template:
    spec:
      containers:
      - name: mongodb
        image: mongo:7.0
      - name: mongodb-exporter
        image: percona/mongodb_exporter:0.40
        args:
        - --mongodb.uri=mongodb://localhost:27017
        - --collect-all
        ports:
        - name: metrics
          containerPort: 9216
```
