# Naming & Labels — Priority P0–P2

Read this file before creating or renaming any Kubernetes resource, namespace, Service, or workload label set.

## P0 — Set app.kubernetes.io/name on every resource

Include `app.kubernetes.io/name` with a short, lowercase, hyphenated application name on every Kubernetes resource, and reuse the same value across all resources of the application. Consistent standard labels let label selectors, ServiceMonitors, PDB matching, Grafana dashboards, and cost reports filter, group, and correlate by service, environment, and ownership without hardcoding resource names or breaking when services are renamed or redeployed.

```yaml
# ✅
metadata:
  labels:
    app.kubernetes.io/name: api-server
    app.kubernetes.io/component: backend
    app.kubernetes.io/instance: production
    environment: production
    team: platform
```

```yaml
# ❌
metadata:
  labels:
    app: api-server
    name: Api Server
```

## P0 — Set app.kubernetes.io/instance to identify each deployment

Include `app.kubernetes.io/instance` to identify the specific deployment of an application, such as `production`, `staging`, or `release-v2`. Without it, multiple deployments of the same application in one cluster are impossible to distinguish.

```yaml
# ✅
metadata:
  labels:
    app.kubernetes.io/name: api-server
    app.kubernetes.io/instance: production
```

```yaml
# ❌
metadata:
  labels:
    app.kubernetes.io/name: api-server
```

## P0 — Name namespaces by environment and team

Use lowercase, hyphenated namespace names that encode environment and team or purpose, such as `prod-api`, `staging-data`, or `monitoring`, and label the namespace with its environment and owning team. Generic names like `default` or `test`, or single-word namespaces, give no context about purpose or environment.

```yaml
# ✅
apiVersion: v1
kind: Namespace
metadata:
  name: prod-api
  labels:
    env: production
    team: backend
```

```yaml
# ❌
apiVersion: v1
kind: Namespace
metadata:
  name: test
```

## P0 — Keep the Service selector in sync with pod labels

Ensure the Service `spec.selector` labels match the `spec.template.metadata.labels` of the targeted Deployment or StatefulSet exactly, including all key-value pairs. Mismatched selectors silently fail to route traffic to pods and are one of the most common Kubernetes debugging traps.

```yaml
# ✅
spec:                    # Service
  selector:
    app: api-server
    component: backend
---
spec:                    # Deployment
  template:
    metadata:
      labels:
        app: api-server
        component: backend
```

```yaml
# ❌
spec:                    # Service selects a label the pods never carry
  selector:
    app: api-server
    tier: backend
---
spec:                    # Deployment pods
  template:
    metadata:
      labels:
        app: api-server
        component: backend
```

## P1 — Mark role, system, and manager with component, part-of, and managed-by

Include `app.kubernetes.io/component` to identify the architectural role of the resource (`frontend`, `backend`, `database`, `cache`, `queue`), `app.kubernetes.io/part-of` to identify the higher-level application or system the resource belongs to, and `app.kubernetes.io/managed-by` to identify the tool or operator responsible for it (`helm`, `kustomize`, `terraform`, `prometheus-operator`). Without them, filtering resources by role in dashboards and automation, seeing which services compose a larger application, and knowing how to update, roll back, or audit infrastructure all require manual investigation.

```yaml
# ✅
metadata:
  labels:
    app.kubernetes.io/name: api-server
    app.kubernetes.io/instance: production
    app.kubernetes.io/component: backend
    app.kubernetes.io/part-of: ecommerce-platform
    app.kubernetes.io/managed-by: helm
```

```yaml
# ❌
metadata:
  labels:
    app.kubernetes.io/name: api-server
```

## P2 — Label every workload with app.kubernetes.io/version

Include `app.kubernetes.io/version` on all workloads to track the deployed version, using semantic versioning such as `1.2.3` or a commit SHA for git-based deployments, and keep the same value on both the workload metadata and the pod template. Non-standard formats or an omitted version label force anyone identifying the running version to inspect container images directly.

```yaml
# ✅
metadata:
  name: user-service
  labels:
    app.kubernetes.io/name: user-service
    app.kubernetes.io/version: "2.1.0"
spec:
  template:
    metadata:
      labels:
        app.kubernetes.io/name: user-service
        app.kubernetes.io/version: "2.1.0"
```

```yaml
# ❌
metadata:
  name: user-service
  labels:
    app.kubernetes.io/name: user-service
```
