---
priority: P1
category: resource-management
---

# Define Resource Quotas per Namespace

**Do**: Define a `ResourceQuota` per namespace limiting total CPU, memory, and pod count to prevent unbounded resource consumption in shared clusters.

**Avoid**: Allowing namespaces to consume unlimited cluster resources, which can starve other workloads and cause cluster-wide instability.

**Example**:
```yaml
apiVersion: v1
kind: ResourceQuota
metadata:
  name: production-quota
  namespace: production
spec:
  hard:
    requests.cpu: "4"
    requests.memory: 8Gi
    limits.cpu: "8"
    limits.memory: 16Gi
    pods: "20"
```
