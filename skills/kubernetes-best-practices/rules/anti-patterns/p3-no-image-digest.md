---
priority: P3
category: anti-patterns
---

# No Image Digest Pinning (Advisory)

**Do**: For maximum supply chain security, pin images to their SHA256 digest (e.g., `nginx@sha256:abc123...`) in addition to or instead of version tags. This guarantees the exact same image bytes are pulled every time.

**Avoid**: Relying solely on mutable tags without digest verification. Even semver tags can be accidentally retagged. Digest pinning prevents supply chain attacks via tag mutation.

**Example**:
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: api
spec:
  template:
    spec:
      containers:
        - name: api
          # Digest pin — immutable, reproducible
          image: myregistry/api@sha256:3a7bd3e2360a3d292b50e5e0f8c6e8d7f9a1b2c3d4e5f6a7b8c9d0e1f2a3b4c5
          # Keep tag as comment for human readability
          # image: myregistry/api:1.4.2
```
