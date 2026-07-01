---
priority: P0
category: observability
---

# Add Prometheus Scrape Annotations to Pods

**Do**: Add `prometheus.io/scrape: "true"`, `prometheus.io/port`, and `prometheus.io/path` annotations to pod templates for services that expose metrics endpoints.

**Avoid**: Relying solely on ServiceMonitor resources; annotations provide a fallback for Prometheus instances that use annotation-based discovery.

**Example**:
```yaml
spec:
  template:
    metadata:
      annotations:
        prometheus.io/scrape: "true"
        prometheus.io/port: "9090"
        prometheus.io/path: /metrics
```
