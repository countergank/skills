---
priority: P0
category: naming-labels
---

# Follow Namespace Naming Conventions

**Do**: Use lowercase, hyphenated namespace names that encode environment and team or purpose (e.g., `prod-api`, `staging-data`, `monitoring`).

**Avoid**: Using generic names like `default`, `test`, or single-word namespaces that provide no context about the namespace's purpose or environment.

**Example**:
```yaml
apiVersion: v1
kind: Namespace
metadata:
  name: prod-api
  labels:
    env: production
    team: backend
```
