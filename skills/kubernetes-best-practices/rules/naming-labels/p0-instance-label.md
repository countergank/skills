---
priority: P0
category: naming-labels
---

# Set the app.kubernetes.io/instance Label

**Do**: Include `app.kubernetes.io/instance` to identify a specific deployment of an application (e.g., `production`, `staging`, `release-v2`).

**Avoid**: Omitting the instance label, which makes it impossible to distinguish between multiple deployments of the same application in one cluster.

**Example**:
```yaml
metadata:
  labels:
    app.kubernetes.io/name: api-server
    app.kubernetes.io/instance: production
```
