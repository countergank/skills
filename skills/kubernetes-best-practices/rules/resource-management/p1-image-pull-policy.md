---
priority: P1
category: resource-management
---

# Set imagePullPolicy Appropriately

**Do**: Pin production images by tag or digest (see `p3-no-image-digest.md` and `p2-image-version-comments.md`) and set `imagePullPolicy: IfNotPresent` for versioned tags, ensuring predictable pull behavior. `pullPolicy: Always` is only for a mutable tag that cannot be avoided in a non-production environment.

**Avoid**: Using the `latest` tag in any environment, and using the `latest` tag without an explicit pull policy, which forces `Always` and causes unnecessary registry traffic and deployment delays.

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
          imagePullPolicy: Always  # Mutable tag — non-production only; production images must be pinned
```
