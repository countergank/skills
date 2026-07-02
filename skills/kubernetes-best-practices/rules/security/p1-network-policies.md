---
priority: P1
category: security
---

# Define Network Policies

**Do**: Create `NetworkPolicy` resources to restrict ingress and egress traffic for each namespace or workload, following the principle of least privilege for pod-to-pod communication.

**Avoid**: Leaving all pods with unrestricted network access, which allows lateral movement if a single pod is compromised.

**Example**:
```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: default-deny-ingress
  namespace: production
spec:
  podSelector: {}
  policyTypes:
    - Ingress
```
