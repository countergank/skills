---
priority: P1
category: observability
---

# Expose Prometheus Metrics on a Named Port

**Do**: Expose `/metrics` on a named port (e.g., `metrics: 9090`) using Prometheus text format. Declare the port in the Service and Pod spec.

**Avoid**: No metrics endpoint or non-standard metric formats — Prometheus cannot scrape what it cannot discover.

**Example**:
```yaml
apiVersion: v1
kind: Service
metadata:
  name: api-server
spec:
  ports:
  - name: http
    port: 80
  - name: metrics
    port: 9090
  selector:
    app: api-server
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: api-server
spec:
  template:
    spec:
      containers:
      - name: app
        ports:
        - name: metrics
          containerPort: 9090
```
