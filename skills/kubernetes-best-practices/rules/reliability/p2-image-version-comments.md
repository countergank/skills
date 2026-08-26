---
priority: P2
category: reliability
---

# Pin Image Versions with Digests for Production

**Do**: Use image digest pinning (`image: nginx@sha256:abc123...`) for production deployments to guarantee immutable, auditable image references.

**Avoid**: Commenting expected image versions that drift from the actual tag — comments rot, and inconsistencies confuse operators during incidents.

**Example**:
```yaml
apiVersion: apps/v1
kind: Deployment
spec:
  template:
    spec:
      containers:
      - name: nginx
        # Pinned to nginx 1.25.3 — verified 2026-01-15
        image: nginx@sha256:2c89e8d9e6e8c7b5f3a1d0e9f8c7b6a5d4c3b2a1
```
