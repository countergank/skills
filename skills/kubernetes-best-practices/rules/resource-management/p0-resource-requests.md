---
priority: P0
category: resource-management
---

# Set Resource Requests

**Do**: Define `requests` for both `cpu` and `memory` on every container to ensure the scheduler places pods on nodes with sufficient resources.

**Avoid**: Omitting requests, which causes the scheduler to assume zero resources and leads to noisy-neighbor problems and OOM kills.

**Example**:
```yaml
resources:
  requests:
    cpu: 100m
    memory: 128Mi
```
