---
priority: P0
category: observability
---

# Label Services for ServiceMonitor Discovery

**Do**: Apply consistent labels to Services that match the `selector` in your Prometheus `ServiceMonitor` resources, using `app.kubernetes.io/name` and `metrics: "true"`.

**Avoid**: Relying on ad-hoc label names or omitting labels that ServiceMonitors select on, which causes metrics scraping to silently fail.

**Example**:
```yaml
apiVersion: v1
kind: Service
metadata:
  name: api-server
  labels:
    app.kubernetes.io/name: api-server
    metrics: "true"
spec:
  ports:
    - name: metrics
      port: 9090
      targetPort: metrics
  selector:
    app.kubernetes.io/name: api-server
```
