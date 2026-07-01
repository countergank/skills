---
priority: P0
category: anti-patterns
---

# Never Use NodePort in Production

**Do**: Use `ClusterIP` for internal service-to-service communication and an `Ingress` controller for external access. Use `LoadBalancer` only when the cloud provider manages it.

**Avoid**: `type: NodePort` in production — it bypasses the Ingress controller, exposes node IPs directly, and creates security and routing complexity.

**Example**:
```yaml
apiVersion: v1
kind: Service
metadata:
  name: api-server
spec:
  type: ClusterIP
  ports:
  - port: 80
  selector:
    app: api-server
---
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: api-server
spec:
  rules:
  - host: api.example.com
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: api-server
            port:
              number: 80
```
