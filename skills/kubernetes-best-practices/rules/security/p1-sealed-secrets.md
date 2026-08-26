---
priority: P1
category: security
---

# Use SealedSecrets for GitOps-Friendly Secret Management

**Do**: Use Bitnami SealedSecrets to encrypt Kubernetes Secrets for safe storage in Git. Encrypt with `kubeseal` before committing.

**Avoid**: Committing raw Kubernetes Secret manifests to version control — plaintext secrets in Git are a security incident waiting to happen, even in private repos.

**Example**:
```yaml
apiVersion: bitnami.com/v1alpha1
kind: SealedSecret
metadata:
  name: db-credentials
  namespace: production
spec:
  encryptedData:
    MONGODB_URI: AgB4xqT2...encrypted_base64...
    MONGODB_PASSWORD: AgC7kLm9...encrypted_base64...
```
