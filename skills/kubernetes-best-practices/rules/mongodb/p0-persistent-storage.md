---
priority: P0
category: mongodb
---

# Use Persistent Storage with Retain Policy

**Do**: Configure PersistentVolumeClaims with `reclaimPolicy: Retain` to prevent data loss when PVCs are deleted or the StatefulSet is torn down.

**Avoid**: Using `ephemeral` storage or `reclaimPolicy: Delete` for MongoDB data volumes, which permanently deletes data on pod rescheduling.

**Example**:
```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: mongodb-data
spec:
  accessModes:
    - ReadWriteOnce
  storageClassName: standard
  resources:
    requests:
      storage: 50Gi
---
apiVersion: v1
kind: PersistentVolume
metadata:
  name: mongodb-pv
spec:
  persistentVolumeReclaimPolicy: Retain
  accessModes:
    - ReadWriteOnce
  capacity:
    storage: 50Gi
```
