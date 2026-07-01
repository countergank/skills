---
priority: P0
category: security
---

# Run Containers as Non-Root

**Do**: Set `securityContext.runAsNonRoot: true` and specify a non-zero `runAsUser` (e.g., 1000).

**Avoid**: Running containers as UID 0 (root). Most official images include a non-root user (e.g., nginx:unprivileged, bitnami/*).

**Example**:
```yaml
securityContext:
  runAsNonRoot: true
  runAsUser: 1000
  runAsGroup: 3000
  fsGroup: 2000
```
