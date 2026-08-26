---
priority: P1
category: resource-management
---

# Set imagePullPolicy Appropriately

**Do**: Set `imagePullPolicy: IfNotPresent` for versioned tags and `Always` for mutable tags (e.g., `latest`, `main`), ensuring predictable pull behavior.

**Avoid**: Using the `latest` tag without an explicit pull policy, which forces `Always` and causes unnecessary registry traffic and deployment delays.

**Example**:
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: api-server
spec:
  template:
    spec:
      containers:
        - name: api
          image: myregistry/api-server:1.4.2
          imagePullPolicy: IfNotPresent  # Versioned tag — pull only if missing
        - name: sidecar
          image: myregistry/sidecar:main
          imagePullPolicy: Always  # Mutable tag — always pull latest
```
