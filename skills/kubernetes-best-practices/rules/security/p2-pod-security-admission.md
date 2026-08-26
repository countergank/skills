---
priority: P2
category: security
---

# Enforce Pod Security Admission

**Do**: Configure the Pod Security Admission (PSA) controller at the namespace level with labels (`pod-security.kubernetes.io/enforce`) to enforce `baseline` or `restricted` security standards.

**Avoid**: Running namespaces without any PSA enforcement, which allows pods with privileged containers, host namespace access, and other dangerous configurations.

**Example**:
```yaml
apiVersion: v1
kind: Namespace
metadata:
  name: production
  labels:
    pod-security.kubernetes.io/enforce: restricted
    pod-security.kubernetes.io/audit: restricted
    pod-security.kubernetes.io/warn: restricted
```
