---
priority: P1
category: mongodb
---

# Configure MongoDB Anti-Affinity

**Do**: Use `podAntiAffinity` with `requiredDuringSchedulingIgnoredDuringExecution` for MongoDB replicas to ensure each pod runs on a different node, protecting against single-node failures.

**Avoid**: Scheduling multiple MongoDB replicas on the same node, which defeats the purpose of replication and causes all replicas to go down if the node fails.

**Example**:
```yaml
spec:
  affinity:
    podAntiAffinity:
      requiredDuringSchedulingIgnoredDuringExecution:
        - labelSelector:
            matchLabels:
              app.kubernetes.io/name: mongodb
              app.kubernetes.io/component: database
          topologyKey: kubernetes.io/hostname
```
