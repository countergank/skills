---
priority: P0
category: security
---

# Disable Host Namespace Sharing

**Do**: Ensure `hostNetwork`, `hostPort`, and `hostPID` are all set to `false` or omitted (defaults to false).

**Avoid**: Sharing host namespaces, which exposes host processes, network interfaces, and allows container escape to the host.

**Example**:
```yaml
spec:
  hostNetwork: false
  hostPID: false
  containers:
    - name: app
      ports:
        - containerPort: 8080
          # No hostPort — use Services for external access
```
