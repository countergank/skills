# Observability — Priority P0

Read this file when adding logging, metrics endpoints, ServiceMonitor discovery, alerting, or tracing to a workload.

## P0 — Write structured logs to stdout

Configure containers to write logs to `stdout` and `stderr` in structured JSON with consistent fields (`level`, `timestamp`, `message`, `traceId`, `spanId`) so the container runtime can capture, rotate, and forward them and the aggregation stack can parse, index, and query them by field. Unstructured text logs written to files inside the container filesystem force regex parsing and are lost on pod restart or eviction.

```yaml
# ✅ Structured JSON written to stdout
env:
  - name: LOG_FORMAT
    value: "json"
  - name: LOG_OUTPUT
    value: "stdout"
  - name: LOG_LEVEL
    value: "info"
```

```yaml
# ❌ Unstructured text written to a file inside the container
env:
  - name: LOG_FILE
    value: /var/log/app.log
```

## P0 — Expose metrics on a named port with scrape annotations

Expose `/metrics` on a named port (for example `metrics: 9090`) in Prometheus text format, declare the port in the Service and Pod spec, and set `prometheus.io/scrape: "true"`, `prometheus.io/port`, and `prometheus.io/path` on the pod template so annotation-based discovery keeps working. Relying solely on ServiceMonitor resources leaves Prometheus instances that scrape by annotations without a fallback.

```yaml
# ✅ Named port plus scrape annotations
ports:
  - name: metrics
    containerPort: 9090
metadata:
  annotations:
    prometheus.io/scrape: "true"
    prometheus.io/port: "9090"
    prometheus.io/path: /metrics
```

```yaml
# ❌ Unnamed port and no scrape annotations
ports:
  - containerPort: 9090
```

## P0 — Label services for ServiceMonitor discovery

Apply labels to Services that match the `selector` in Prometheus `ServiceMonitor` resources, using `app.kubernetes.io/name` and `metrics: "true"`. Ad-hoc label names or omitted labels make metrics scraping fail silently.

```yaml
# ✅ Labels the ServiceMonitor selector matches
metadata:
  labels:
    app.kubernetes.io/name: api-server
    metrics: "true"
spec:
  ports:
    - name: metrics
      port: 9090
```

```yaml
# ❌ No labels, so ServiceMonitor discovery fails
metadata:
  name: api-server
```

## P1 — Alert on SLOs with runbook links

Create `PrometheusRule` resources with alert thresholds for critical SLOs (error rate, latency, saturation) and route them to PagerDuty, Slack, or email with a clear runbook link. Alert on user-impacting conditions such as error-budget burn, not symptoms such as high CPU.

```yaml
# ✅ Error-rate SLO alert with a runbook link
- alert: HighErrorRate
  expr: |
    sum(rate(http_requests_total{job="api-server",code=~"5.."}[5m]))
    / sum(rate(http_requests_total{job="api-server"}[5m])) > 0.05
  for: 5m
  labels:
    severity: critical
  annotations:
    runbook_url: "https://wiki.example.com/runbooks/high-error-rate"
```

```yaml
# ❌ Alert fires on a symptom, not user impact
- alert: HighCPU
  expr: cpu_usage > 0.9
```

## P1 — Propagate tracing context across services

Inject tracing context (`traceId`, `spanId`, `parentSpanId`) into pod environment variables or sidecar configuration so distributed traces link requests across every service in the call chain. Services without context propagation cannot be traced end-to-end, hiding the root cause of latency issues.

```yaml
# ✅ OpenTelemetry env vars on every service
env:
  - name: OTEL_SERVICE_NAME
    value: "api-server"
  - name: OTEL_EXPORTER_OTLP_ENDPOINT
    value: "http://otel-collector:4317"
  - name: OTEL_PROPAGATORS
    value: "tracecontext,baggage"
```

```yaml
# ❌ No OTEL_* variables, so traces break at each hop
containers:
  - name: api-server
    image: myapp:1.2.3
```
