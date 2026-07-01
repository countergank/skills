---
priority: P1
category: reliability
---

# Spread Replicas Across Nodes with Pod Anti-Affinity

**Do**: Define `podAntiAffinity` with `preferredDuringScheduling` to spread replicas across different nodes, avoiding single points of failure.

**Avoid**: All replicas co-located on the same node — a node failure takes down the entire workload.

**Example**:
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: api-server
spec:
  replicas: 3
  template:
    spec:
      affinity:
        podAntiAffinity:
          preferredDuringSchedulingIgnoredDuringExecution:
          - weight: 100
            podAffinityTerm:
              labelSelector:
                matchLabels:
                  app: api-server
              topologyKey: kubernetes.io/hostname
```
