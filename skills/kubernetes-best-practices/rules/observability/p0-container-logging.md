---
priority: P0
category: observability
---

# Log to Stdout and Stderr

**Do**: Configure containers to write logs to `stdout` and `stderr` so the container runtime can capture, rotate, and forward them to the centralized logging stack.

**Avoid**: Writing logs to files inside the container filesystem, which are lost when the pod is evicted or restarted and require sidecar log shippers.

**Example**:
```yaml
containers:
  - name: app
    image: myapp:1.2.3
    env:
      - name: LOG_FORMAT
        value: "json"
      - name: LOG_OUTPUT
        value: "stdout"
```
