---
priority: P1
category: reliability
---

# Set Termination Grace Period

**Do**: Configure `terminationGracePeriodSeconds` to give your application enough time to finish in-flight requests, drain connections, and shut down gracefully before Kubernetes sends `SIGKILL`.

**Avoid**: Using the default 30-second grace period for workloads that need more time to drain, or setting it to 0 and risking data loss and incomplete transactions.

**Example**:
```yaml
spec:
  terminationGracePeriodSeconds: 60
  containers:
    - name: api-server
      image: myapp:1.2.3
      lifecycle:
        preStop:
          exec:
            command: ["sh", "-c", "sleep 10 && curl -X POST http://localhost:8080/drain"]
```
