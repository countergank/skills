---
priority: P0
category: naming-labels
---

# Match Service Selectors to Pod Labels Exactly

**Do**: Ensure Service `spec.selector` labels match the `spec.template.metadata.labels` of the targeted Deployment or StatefulSet exactly — including all key-value pairs.

**Avoid**: Mismatched selectors — traffic silently fails to route to pods. This is one of the most common K8s debugging traps.

**Example**:
```yaml
apiVersion: v1
kind: Service
metadata:
  name: api-server
spec:
  selector:
    app: api-server
    component: backend
  ports:
  - port: 80
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: api-server
spec:
  selector:
    matchLabels:
      app: api-server
  template:
    metadata:
      labels:
        app: api-server
        component: backend
```
