---
priority: P1
category: naming-labels
---

# Set the app.kubernetes.io/component Label

**Do**: Include `app.kubernetes.io/component` to identify the role of a resource within the application (e.g., `frontend`, `backend`, `database`, `cache`, `queue`).

**Avoid**: Omitting the component label, which makes it difficult to filter resources by their architectural role in dashboards, queries, and automation scripts.

**Example**:
```yaml
metadata:
  labels:
    app.kubernetes.io/name: api-server
    app.kubernetes.io/component: backend
    app.kubernetes.io/instance: production
```
