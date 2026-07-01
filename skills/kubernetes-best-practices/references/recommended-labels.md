# Recommended Kubernetes Labels

Kubernetes recommends a set of common labels to provide consistency across tooling, dashboards, and automation. These labels enable grouping, filtering, and identification of resources.

Source: [kubernetes.io/docs/concepts/overview/working-with-objects/common-labels](https://kubernetes.io/docs/concepts/overview/working-with-objects/common-labels/)

## Required Labels

### `app.kubernetes.io/name`

The name of the application. This should be a short, descriptive identifier.

- **Example**: `nginx`, `redis`, `user-service`
- **Scope**: Consistent across all resources belonging to the same application

### `app.kubernetes.io/instance`

A unique name identifying the instance of an application. Distinguishes between multiple deployments of the same app (e.g., dev, staging, prod).

- **Example**: `user-service-prod`, `nginx-abc123`
- **Scope**: Unique per deployment instance

### `app.kubernetes.io/version`

The current version of the application (e.g., a semver or revision identifier).

- **Example**: `1.2.3`, `v2024.01.15`, `a1b2c3d`
- **Scope**: Updated with each release

## Recommended Labels

### `app.kubernetes.io/component`

The component within the architecture. Identifies the role of a resource within a multi-component application.

- **Example**: `api`, `frontend`, `database`, `cache`
- **Scope**: Helps distinguish tiers in multi-tier applications

### `app.kubernetes.io/part-of`

The name of a higher-level application this one is part of. Groups related applications under a common umbrella.

- **Example**: `ecommerce-platform`, `monitoring-stack`
- **Scope**: Enables grouping of microservices under a product

### `app.kubernetes.io/managed-by`

The tool being used to manage the operation of an application.

- **Example**: `helm`, `kubectl`, `argocd`, `terraform`, `cdk8s`
- **Scope**: Useful for automation and drift detection

## Usage Example

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: user-service
  labels:
    app.kubernetes.io/name: user-service
    app.kubernetes.io/instance: user-service-prod
    app.kubernetes.io/version: "2.1.0"
    app.kubernetes.io/component: api
    app.kubernetes.io/part-of: ecommerce-platform
    app.kubernetes.io/managed-by: helm
spec:
  selector:
    matchLabels:
      app.kubernetes.io/name: user-service
      app.kubernetes.io/instance: user-service-prod
  template:
    metadata:
      labels:
        app.kubernetes.io/name: user-service
        app.kubernetes.io/instance: user-service-prod
        app.kubernetes.io/version: "2.1.0"
        app.kubernetes.io/component: api
        app.kubernetes.io/part-of: ecommerce-platform
        app.kubernetes.io/managed-by: helm
```

## Label Propagation

Labels should be applied consistently across all resources belonging to the same workload:

- **Deployment/StatefulSet/DaemonSet**: metadata.labels + spec.selector.matchLabels + spec.template.metadata.labels
- **Service**: metadata.labels + spec.selector (must match pod labels)
- **Ingress**: metadata.labels
- **ConfigMap/Secret**: metadata.labels (for association with workloads)

## Minimum Set

At minimum, every workload MUST have:

1. `app.kubernetes.io/name`
2. `app.kubernetes.io/instance`
3. `app.kubernetes.io/version`
