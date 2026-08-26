---
priority: P0
category: resource-management
---

# Configure Memory Limits

**Do**: Set `memory` limits slightly above requests (e.g., 1.5-2x) to allow for transient spikes while ensuring the container is OOM-killed before impacting the node.

**Avoid**: Setting memory limits far above actual usage (wasted capacity) or below peak usage (frequent OOM kills).

**Example**:
```yaml
resources:
  requests:
    memory: 256Mi
  limits:
    memory: 512Mi
```
