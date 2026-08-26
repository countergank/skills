---
priority: P2
category: resource-management
---

# Limit Ranges for Namespace Defaults

**Do**: Define `LimitRange` objects in each namespace to set default resource requests and limits for containers that don't specify them. This prevents BestEffort pods from slipping through.

**Avoid**: Relying on developers to always specify resources manually. Human error will leave containers without limits.

**Example**:
```yaml
apiVersion: v1
kind: LimitRange
metadata:
  name: default-limits
  namespace: production
spec:
  limits:
    - type: Container
      default:
        cpu: 500m
        memory: 256Mi
      defaultRequest:
        cpu: 100m
        memory: 128Mi
      max:
        cpu: "2"
        memory: 1Gi
      min:
        cpu: 50m
        memory: 64Mi
```
