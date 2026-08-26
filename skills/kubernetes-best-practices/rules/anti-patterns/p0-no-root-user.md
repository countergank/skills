---
priority: P0
category: anti-patterns
---

# No Root User

**Do**: Run all containers as a non-root user. Set `runAsNonRoot: true` and specify a `runAsUser` (e.g., 1000) in the pod or container security context. Use unprivileged base images (e.g., `distroless`, `alpine`, `bitnami/*`).

**Avoid**: Running containers as UID 0 (root). If a container is compromised while running as root, the attacker gains full control of the container and potentially the node.

**Example**:
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: api
spec:
  template:
    spec:
      securityContext:
        runAsNonRoot: true
        runAsUser: 1000
        runAsGroup: 3000
        fsGroup: 2000
      containers:
        - name: api
          image: myregistry/api:2.0.0
          securityContext:
            runAsNonRoot: true
            runAsUser: 1000
```
