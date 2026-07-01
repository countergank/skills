---
priority: P1
category: anti-patterns
---

# No Default Namespace

**Do**: Always deploy workloads into explicitly named namespaces (e.g., `production`, `staging`, `monitoring`). Define namespaces as first-class resources with resource quotas and network policies.

**Avoid**: Deploying to the `default` namespace. The default namespace has no resource quotas, no network policies, and no isolation — it becomes a shared, unmanaged space that violates multi-tenant security.

**Example**:
```yaml
# Define namespace first
apiVersion: v1
kind: Namespace
metadata:
  name: production
  labels:
    environment: production
---
# Deploy into explicit namespace
apiVersion: apps/v1
kind: Deployment
metadata:
  name: api
  namespace: production
spec:
  template:
    spec:
      containers:
        - name: api
          image: myregistry/api:1.0.0
```
