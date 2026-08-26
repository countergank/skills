---
priority: P2
category: naming-labels
---

# Version Label

**Do**: Include `app.kubernetes.io/version` on all workloads to track the deployed version. Use semantic versioning (e.g., `1.2.3`) or commit SHA for git-based deployments.

**Avoid**: Omitting the version label or using non-standard formats. Without it, identifying which version is running requires inspecting container images directly.

**Example**:
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: user-service
  labels:
    app.kubernetes.io/name: user-service
    app.kubernetes.io/version: "2.1.0"
spec:
  template:
    metadata:
      labels:
        app.kubernetes.io/name: user-service
        app.kubernetes.io/version: "2.1.0"
```
