---
priority: P1
category: reliability
---

# Assign Priority Classes to Production Workloads

**Do**: Set `priorityClassName` on production Deployments and StatefulSets to ensure scheduling priority and prevent eviction of critical workloads.

**Avoid**: Relying on the default priority (0) for production services — they may be evicted before system or low-priority pods.

**Example**:
```yaml
apiVersion: scheduling.k8s.io/v1
kind: PriorityClass
metadata:
  name: production-high
value: 1000000
globalDefault: false
description: "Production workloads that must not be preempted"
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: api-server
spec:
  template:
    spec:
      priorityClassName: production-high
```
