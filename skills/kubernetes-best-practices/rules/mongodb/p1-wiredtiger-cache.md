---
priority: P1
category: mongodb
---

# Configure WiredTiger Cache Size for Memory Limits

**Do**: Set `--wiredTigerCacheSizeGB` to a value ≤ 50% of the container memory limit. MongoDB defaults to using 50% of system RAM, which causes OOMKill in containers with memory limits.

**Avoid**: Running MongoDB without explicit WiredTiger cache configuration — the OOM killer will terminate the process under memory pressure.

**Example**:
```yaml
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: mongodb
spec:
  template:
    spec:
      containers:
      - name: mongodb
        image: mongo:7.0
        args:
        - --wiredTigerCacheSizeGB=2
        resources:
          limits:
            memory: "4Gi"
          requests:
            memory: "4Gi"
```
