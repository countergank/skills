---
priority: P2
category: observability
---

# Cost Allocation Labels

**Do**: Add cost allocation labels (e.g., `cost-center`, `team`, `environment`) to all workloads so cluster cost can be attributed accurately. Tools like Kubecost and OpenCost use these labels for chargeback reporting.

**Avoid**: Deploying workloads without cost attribution labels. Without them, cluster costs are impossible to distribute across teams or projects.

**Example**:
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: payment-service
  labels:
    app.kubernetes.io/name: payment-service
    cost-center: "payments"
    team: "backend"
    environment: "production"
spec:
  template:
    metadata:
      labels:
        app.kubernetes.io/name: payment-service
        cost-center: "payments"
        team: "backend"
        environment: "production"
```
