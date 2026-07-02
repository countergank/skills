---
priority: P0
category: reliability
---

# Configure Pod Disruption Budgets

**Do**: Define a `PodDisruptionBudget` for every production workload to limit voluntary disruptions during node drains, cluster upgrades, and autoscaling events.

**Avoid**: Running production workloads without a PDB, which allows cluster operations to take down all replicas simultaneously.

**Example**:
```yaml
apiVersion: policy/v1
kind: PodDisruptionBudget
metadata:
  name: api-server-pdb
spec:
  minAvailable: 1
  selector:
    matchLabels:
      app.kubernetes.io/name: api-server
```
