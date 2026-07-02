---
priority: P0
category: reliability
---

# Configure Readiness Probes

**Do**: Define a `readinessProbe` for every container so Kubernetes only sends traffic to pods that are ready to serve requests.

**Avoid**: Relying solely on container startup; a process can be running but not ready to accept traffic (e.g., still loading data or waiting for dependencies).

**Example**:
```yaml
readinessProbe:
  httpGet:
    path: /healthz/ready
    port: 8080
  initialDelaySeconds: 5
  periodSeconds: 10
  failureThreshold: 3
```
