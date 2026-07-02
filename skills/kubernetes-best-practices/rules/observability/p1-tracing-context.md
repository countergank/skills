---
priority: P1
category: observability
---

# Propagate Tracing Context

**Do**: Inject tracing context (`traceId`, `spanId`, `parentSpanId`) into pod environment variables or sidecar configuration so distributed traces link requests across all services in the call chain.

**Avoid**: Running services without tracing context propagation, which makes it impossible to trace a request end-to-end across microservices and obscures the root cause of latency issues.

**Example**:
```yaml
containers:
  - name: api-server
    image: myapp:1.2.3
    env:
      - name: OTEL_SERVICE_NAME
        value: "api-server"
      - name: OTEL_EXPORTER_OTLP_ENDPOINT
        value: "http://otel-collector:4317"
      - name: OTEL_PROPAGATORS
        value: "tracecontext,baggage"
```
