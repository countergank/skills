---
priority: P1
category: reliability
---

# Configure Topology Spread Constraints

**Do**: Define `topologySpreadConstraints` to distribute pods evenly across availability zones, nodes, or hostnames, ensuring high availability when a zone or node fails.

**Avoid**: Relying only on anti-affinity rules, which prevent co-location but don't guarantee balanced distribution across failure domains.

**Example**:
```yaml
spec:
  topologySpreadConstraints:
    - maxSkew: 1
      topologyKey: topology.kubernetes.io/zone
      whenUnsatisfiable: DoNotSchedule
      labelSelector:
        matchLabels:
          app.kubernetes.io/name: api-server
```
