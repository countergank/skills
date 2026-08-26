---
priority: P1
category: security
---

# Disable Automount of Service Account Token

**Do**: Set `automountServiceAccountToken: false` on pods or service accounts unless the container explicitly needs access to the Kubernetes API.

**Avoid**: Leaving the default service account token mounted in every pod, which provides unnecessary API credentials that can be exploited if the container is compromised.

**Example**:
```yaml
spec:
  automountServiceAccountToken: false
  containers:
    - name: app
      image: myapp:1.2.3
```
