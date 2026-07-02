---
priority: P0
category: naming-labels
---

# Set the app.kubernetes.io/name Label

**Do**: Include `app.kubernetes.io/name` with a short, lowercase, hyphenated application name on every Kubernetes resource.

**Avoid**: Using arbitrary or inconsistent names across resources, which breaks label selectors, ServiceMonitors, and PDB matching.

**Example**:
```yaml
metadata:
  labels:
    app.kubernetes.io/name: api-server
    app.kubernetes.io/instance: production
```
