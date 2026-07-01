---
priority: P0
category: resource-management
---

# Set Resource Limits

**Do**: Define `limits` for both `cpu` and `memory` on every container to prevent runaway processes from consuming unbounded resources.

**Avoid**: Setting requests without limits, which allows a single container to starve others on the same node.

**Example**:
```yaml
resources:
  requests:
    cpu: 100m
    memory: 128Mi
  limits:
    cpu: 500m
    memory: 256Mi
```
