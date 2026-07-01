---
priority: P0
category: security
---

# Disable Privilege Escalation

**Do**: Set `allowPrivilegeEscalation: false` to prevent child processes from gaining more privileges than the parent.

**Avoid**: Allowing privilege escalation, which enables exploits like SUID binaries to elevate to root inside the container.

**Example**:
```yaml
securityContext:
  allowPrivilegeEscalation: false
```
