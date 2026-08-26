---
priority: P1
category: anti-patterns
---

# Missing Probes

**Do**: Always configure both `readinessProbe` and `livenessProbe` for every container. Use separate endpoints or commands that accurately reflect application health.

**Avoid**: Deploying containers without any probes. Without probes, Kubernetes cannot detect or recover from application failures, and traffic continues to flow to unhealthy pods.

**Example**:
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: api
spec:
  template:
    spec:
      containers:
        - name: api
          image: myregistry/api:1.0.0
          readinessProbe:
            httpGet:
              path: /health/ready
              port: 8080
            initialDelaySeconds: 5
            periodSeconds: 10
          livenessProbe:
            httpGet:
              path: /health/live
              port: 8080
            initialDelaySeconds: 15
            periodSeconds: 20
```
