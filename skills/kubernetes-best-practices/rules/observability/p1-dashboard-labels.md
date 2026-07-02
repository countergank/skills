---
priority: P1
category: observability
---

# Set Dashboard Labels

**Do**: Include standard labels (`app.kubernetes.io/name`, `app.kubernetes.io/component`, `environment`, `team`) on all Kubernetes resources so Grafana dashboards and observability tools can filter, group, and correlate metrics by service, environment, and ownership.

**Avoid**: Deploying resources without consistent labels, which forces dashboard queries to hardcode resource names and breaks when services are renamed or redeployed.

**Example**:
```yaml
metadata:
  labels:
    app.kubernetes.io/name: api-server
    app.kubernetes.io/component: backend
    environment: production
    team: platform
```
