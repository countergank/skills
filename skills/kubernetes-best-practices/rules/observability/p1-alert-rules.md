---
priority: P1
category: observability
---

# Define Alert Rules

**Do**: Create `PrometheusRule` resources with alerting thresholds for critical SLOs (error rate, latency, saturation) and route them to PagerDuty, Slack, or email with clear runbook links.

**Avoid**: Monitoring without alerts, or defining alerts that fire on symptoms (CPU high) instead of user-impacting conditions (error budget burn).

**Example**:
```yaml
apiVersion: monitoring.coreos.com/v1
kind: PrometheusRule
metadata:
  name: api-server-alerts
  labels:
    app.kubernetes.io/name: api-server
spec:
  groups:
    - name: api-server.rules
      rules:
        - alert: HighErrorRate
          expr: |
            sum(rate(http_requests_total{job="api-server",code=~"5.."}[5m]))
            /
            sum(rate(http_requests_total{job="api-server"}[5m]))
            > 0.05
          for: 5m
          labels:
            severity: critical
          annotations:
            summary: "API server error rate above 5%"
            runbook_url: "https://wiki.example.com/runbooks/high-error-rate"
```
