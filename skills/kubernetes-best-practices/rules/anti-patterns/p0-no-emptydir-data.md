---
priority: P0
category: anti-patterns
---

# Never Use emptyDir for Persistent or Stateful Data

**Do**: Use `PersistentVolumeClaim` or `volumeClaimTemplates` (for StatefulSets) for any data that must survive pod restarts — databases, queues, file uploads, caches that need persistence.

**Avoid**: `emptyDir` for databases, message queues, or any stateful workload — data is lost on pod restart, eviction, or node failure.

**Example**:
```yaml
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: mongodb
spec:
  volumeClaimTemplates:
  - metadata:
      name: data
    spec:
      accessModes:
      - ReadWriteOnce
      resources:
        requests:
          storage: 20Gi
      storageClassName: standard
  template:
    spec:
      containers:
      - name: mongodb
        volumeMounts:
        - name: data
          mountPath: /data/db
```
