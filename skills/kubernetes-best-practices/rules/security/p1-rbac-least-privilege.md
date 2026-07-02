---
priority: P1
category: security
---

# RBAC Least Privilege for Service Accounts

**Do**: Create a dedicated `ServiceAccount` per workload with minimal `Role` bindings scoped to only the resources and verbs the application actually needs. Never bind `cluster-admin` to app workloads.

**Avoid**: Using the default `ServiceAccount` or granting `cluster-admin` to application pods, which gives unnecessary cluster-wide privileges.

**Example**:
```yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: api-server-sa
  namespace: production
---
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: api-server-role
  namespace: production
rules:
  - apiGroups: [""]
    resources: ["configmaps"]
    verbs: ["get", "list"]
---
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: api-server-rolebinding
  namespace: production
subjects:
  - kind: ServiceAccount
    name: api-server-sa
    namespace: production
roleRef:
  kind: Role
  name: api-server-role
  apiGroup: rbac.authorization.k8s.io
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: api-server
spec:
  template:
    spec:
      serviceAccountName: api-server-sa
      containers:
        - name: api
          image: myregistry/api-server:1.4.2
```
