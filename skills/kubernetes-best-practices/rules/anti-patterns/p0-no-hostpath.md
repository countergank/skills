---
priority: P0
category: anti-patterns
---

# Avoid hostPath Volumes — Use PersistentVolumeClaims

**Do**: Use `PersistentVolumeClaim` with a `StorageClass` for persistent storage. PVCs are portable across nodes and survive pod rescheduling.

**Avoid**: `hostPath` volumes — they bind data to a specific node, are not portable, and open security risks (container escaping to node filesystem).

**Example**:
```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: data-pvc
spec:
  accessModes:
  - ReadWriteOnce
  resources:
    requests:
      storage: 10Gi
  storageClassName: standard
---
apiVersion: apps/v1
kind: Deployment
spec:
  template:
    spec:
      volumes:
      - name: data
        persistentVolumeClaim:
          claimName: data-pvc
```
