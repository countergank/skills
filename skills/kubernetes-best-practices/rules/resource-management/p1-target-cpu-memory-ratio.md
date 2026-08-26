---
priority: P1
category: resource-management
---

# Set Target CPU and Memory Ratio

**Do**: Configure resource requests and limits so that the limit-to-request ratio is reasonable — typically 1.5x to 2x for CPU and 1.2x to 1.5x for memory — allowing burst capacity while preventing resource starvation.

**Avoid**: Setting limits equal to requests (no burst allowed) or setting limits far above requests (e.g., 10x), which causes unpredictable scheduling and noisy-neighbor issues.

**Example**:
```yaml
resources:
  requests:
    cpu: 200m
    memory: 256Mi
  limits:
    cpu: 400m
    memory: 384Mi
```
