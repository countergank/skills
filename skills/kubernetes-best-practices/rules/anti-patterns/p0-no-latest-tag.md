---
priority: P0
category: anti-patterns
---

# No Latest Tag

**Do**: Always pin container images to a specific semantic version tag (e.g., `nginx:1.25.3`) or a digest (`nginx@sha256:...`). This ensures reproducible deployments.

**Avoid**: Using `latest` or omitting the tag entirely. The `latest` tag is mutable and unpredictable — the same manifest can pull different images across deployments, breaking reproducibility and rollback guarantees.

**Example**:
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: web-app
spec:
  template:
    spec:
      containers:
        - name: web
          image: myregistry/web-app:1.4.2  # Pinned semver tag
        - name: sidecar
          image: myregistry/sidecar@sha256:abc123...  # Digest for immutability
```
