---
priority: P0
category: resource-management
---

# Configure CPU Limits

**Do**: Set `cpu` limits to a reasonable multiple of requests (e.g., 2-5x) to allow burst capacity while preventing CPU starvation of other workloads.

**Avoid**: Setting CPU limits equal to requests (no burst) or omitting it entirely (unbounded CPU usage).

**Example**:
```yaml
resources:
  requests:
    cpu: 250m
  limits:
    cpu: "1"
```
