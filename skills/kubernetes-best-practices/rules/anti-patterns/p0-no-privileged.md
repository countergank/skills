---
priority: P0
category: anti-patterns
---

# No Privileged Containers

**Do**: Never run containers with `privileged: true`. Use the minimum required capabilities and security context settings instead. Most workloads need zero elevated privileges.

**Avoid**: Setting `securityContext.privileged: true` or using `privileged: true` in Pod Security Standards. A privileged container has full access to the host, effectively bypassing all container isolation.

**Example**:
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: app
spec:
  template:
    spec:
      containers:
        - name: app
          image: myregistry/app:1.0.0
          securityContext:
            privileged: false  # Explicit denial
            allowPrivilegeEscalation: false
            capabilities:
              drop:
                - ALL
```
