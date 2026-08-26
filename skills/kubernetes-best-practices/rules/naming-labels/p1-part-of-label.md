---
priority: P1
category: naming-labels
---

# Set the app.kubernetes.io/part-of Label

**Do**: Include `app.kubernetes.io/part-of` to identify the higher-level application or system that a resource belongs to, grouping related microservices under a common umbrella.

**Avoid**: Deploying microservices without a `part-of` label, which makes it impossible to see which services compose a larger application in dashboards or cost allocation reports.

**Example**:
```yaml
metadata:
  labels:
    app.kubernetes.io/name: api-server
    app.kubernetes.io/part-of: ecommerce-platform
    app.kubernetes.io/instance: production
```
