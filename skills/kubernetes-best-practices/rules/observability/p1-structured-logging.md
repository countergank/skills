---
priority: P1
category: observability
---

# Use Structured Logging

**Do**: Configure application logs in structured JSON format with consistent fields (`level`, `timestamp`, `message`, `traceId`, `spanId`) so log aggregation systems can parse, index, and query them efficiently.

**Avoid**: Writing unstructured text logs that require regex-based parsing, lose field-level filtering capability, and make correlation across services difficult.

**Example**:
```yaml
containers:
  - name: app
    image: myapp:1.2.3
    env:
      - name: LOG_FORMAT
        value: "json"
      - name: LOG_LEVEL
        value: "info"
```
