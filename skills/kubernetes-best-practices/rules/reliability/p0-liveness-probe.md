---
priority: P0
category: reliability
---

# Configure Liveness Probes

**Do**: Define a `livenessProbe` for every container so Kubernetes can detect and restart unhealthy pods that are stuck or deadlocked.

**Avoid**: Using the same endpoint for both liveness and readiness probes; liveness should check if the process is alive, readiness should check if it can serve traffic.

**Example**:
```yaml
livenessProbe:
  httpGet:
    path: /healthz/live
    port: 8080
  initialDelaySeconds: 15
  periodSeconds: 20
  failureThreshold: 3
```
