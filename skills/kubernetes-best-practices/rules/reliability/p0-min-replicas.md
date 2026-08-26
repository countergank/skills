---
priority: P0
category: reliability
---

# Set Minimum Two Replicas for Production

**Do**: Configure `replicas: 2` or higher for all production workloads to ensure availability during node failures, rolling updates, and maintenance.

**Avoid**: Running production services with a single replica, which creates a single point of failure and causes downtime during deployments.

**Example**:
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: api-server
spec:
  replicas: 3
  strategy:
    rollingUpdate:
      maxSurge: 1
      maxUnavailable: 0
```
