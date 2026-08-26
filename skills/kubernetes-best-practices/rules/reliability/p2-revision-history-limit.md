---
priority: P2
category: reliability
---

# Revision History Limit

**Do**: Set `revisionHistoryLimit` on Deployments and StatefulSets to control how many old ReplicaSets are retained. A value of 3-5 is sufficient for rollbacks without accumulating garbage.

**Avoid**: Leaving the default (10) or setting it to 0. The default wastes etcd storage; 0 disables rollbacks entirely.

**Example**:
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: api-server
spec:
  replicas: 3
  revisionHistoryLimit: 5
  template:
    spec:
      containers:
        - name: api
          image: myregistry/api-server:1.2.3
```
