---
priority: P1
category: reliability
---

# Configure Startup Probe

**Do**: Define a `startupProbe` for containers that have a slow initialization phase (e.g., loading large datasets, warming caches, running migrations) so Kubernetes waits before running liveness checks.

**Avoid**: Relying only on liveness probes with a long `initialDelaySeconds`, which delays failure detection for the entire lifetime of the pod even after startup completes.

**Example**:
```yaml
startupProbe:
  httpGet:
    path: /healthz/startup
    port: 8080
  failureThreshold: 30
  periodSeconds: 10
```
