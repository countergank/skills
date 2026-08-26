---
priority: P0
category: security
---

# Use Read-Only Root Filesystem

**Do**: Set `readOnlyRootFilesystem: true` and mount `emptyDir` volumes for paths that require write access (e.g., `/tmp`, `/var/run`).

**Avoid**: Leaving the root filesystem writable, which allows attackers to modify binaries or inject malicious files.

**Example**:
```yaml
securityContext:
  readOnlyRootFilesystem: true
volumeMounts:
  - name: tmp
    mountPath: /tmp
  - name: var-run
    mountPath: /var/run
volumes:
  - name: tmp
    emptyDir: {}
  - name: var-run
    emptyDir: {}
```
