---
priority: P1
category: naming-labels
---

# Set the app.kubernetes.io/managed-by Label

**Do**: Include `app.kubernetes.io/managed-by` to identify the tool or operator responsible for managing the resource (e.g., `helm`, `kustomize`, `terraform`, `prometheus-operator`).

**Avoid**: Leaving resources without a `managed-by` label, which makes it unclear how to update, rollback, or audit infrastructure changes.

**Example**:
```yaml
metadata:
  labels:
    app.kubernetes.io/name: api-server
    app.kubernetes.io/managed-by: helm
    app.kubernetes.io/instance: production
```
