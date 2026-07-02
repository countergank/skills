---
priority: P1
category: resource-management
---

# Configure Horizontal Pod Autoscaler

**Do**: Define a `HorizontalPodAutoscaler` with CPU and/or memory targets to automatically scale replicas based on actual utilization, ensuring capacity matches demand.

**Avoid**: Running workloads with a fixed replica count that doesn't adapt to traffic patterns, resulting in over-provisioning during low load or degraded performance during spikes.

**Example**:
```yaml
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: api-server-hpa
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: api-server
  minReplicas: 2
  maxReplicas: 10
  metrics:
    - type: Resource
      resource:
        name: cpu
        target:
          type: Utilization
          averageUtilization: 70
```
