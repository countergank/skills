---
priority: P1
category: security
---

# Configure Seccomp Profile

**Do**: Set a seccomp profile (`RuntimeDefault` or a custom profile) in the pod or container `securityContext` to restrict the system calls available to the container.

**Avoid**: Running containers with `Unconfined` seccomp, which allows unrestricted access to all kernel syscalls and increases the attack surface.

**Example**:
```yaml
securityContext:
  seccompProfile:
    type: RuntimeDefault
```
