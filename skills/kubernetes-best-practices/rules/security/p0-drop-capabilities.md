---
priority: P0
category: security
---

# Drop All Capabilities

**Do**: Drop `ALL` Linux capabilities and add back only the specific ones the container needs (e.g., `NET_BIND_SERVICE` for ports < 1024).

**Avoid**: Running with the default capability set, which includes dangerous capabilities like `SYS_ADMIN` and `NET_RAW`.

**Example**:
```yaml
securityContext:
  capabilities:
    drop:
      - ALL
    add:
      - NET_BIND_SERVICE
```
