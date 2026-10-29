# Resource Management — Priority P0

Read this file when a workload defines or reviews the compute resources it may consume.

## P0 — Set requests and limits on every container

Define `requests` for both `cpu` and `memory` on every container so the scheduler places pods on nodes with sufficient resources, and define `limits` for both so a runaway process cannot consume unbounded resources. Omitting requests makes the scheduler assume zero resources, which causes noisy-neighbor problems and OOM kills; setting requests without limits lets a single container starve others on the same node.

```yaml
// ✅ Requests and limits on both dimensions
resources:
  requests:
    cpu: 100m
    memory: 128Mi
  limits:
    cpu: 500m
    memory: 256Mi
```

```yaml
// ❌ No resources field: scheduled as zero, first to be evicted
containers:
- name: api
  image: api:1.0
```

## P0 — Size each limit as a ratio of its request

Set every limit as a multiple of its request: 2-5x for CPU, which is compressible and throttling rather than death, so a high ceiling enables bursts; and 1.2-1.5x for memory, which is not compressible, so a limit far above the request only delays the OOM kill. A limit equal to its request allows no burst at all.

```yaml
// ✅ CPU 4x for burst headroom, memory 1.5x for transient spikes
resources:
  requests:
    cpu: 250m
    memory: 256Mi
  limits:
    cpu: "1"
    memory: 384Mi
```

```yaml
// ❌ CPU at 1x forbids burst; memory at 8x only postpones the OOM kill
resources:
  requests:
    cpu: 250m
    memory: 256Mi
  limits:
    cpu: 250m
    memory: 2Gi
```

## P1 — Scale replicas with a HorizontalPodAutoscaler

Define a `HorizontalPodAutoscaler` with CPU and/or memory targets so replicas scale automatically on actual utilization and capacity matches demand. A fixed replica count over-provisions during low load and degrades performance during spikes.

```yaml
// ✅ Autoscaling between 2 and 10 replicas at 70% CPU
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
spec:
  scaleTargetRef: {apiVersion: apps/v1, kind: Deployment, name: api-server}
  minReplicas: 2
  maxReplicas: 10
  metrics:
  - type: Resource
    resource: {name: cpu, target: {type: Utilization, averageUtilization: 70}}
```

```yaml
// ❌ Hard-coded replica count that never adapts to traffic
spec:
  replicas: 5
  template:
    spec:
      containers:
      - name: api
```

## P1 — Cap every namespace with a ResourceQuota

Define a `ResourceQuota` per namespace that limits total CPU, memory, and pod count so one namespace cannot consume unbounded cluster resources and starve other workloads into cluster-wide instability.

```yaml
// ✅ Namespace-wide ceiling on requests, limits, and pods
apiVersion: v1
kind: ResourceQuota
metadata: {name: production-quota, namespace: production}
spec:
  hard:
    requests.cpu: "4"
    requests.memory: 8Gi
    limits.cpu: "8"
    limits.memory: 16Gi
    pods: "20"
```

```yaml
// ❌ Namespace created with no quota behind it
apiVersion: v1
kind: Namespace
metadata:
  name: production
```

## P2 — Default container resources with a LimitRange

Define `LimitRange` objects in each namespace to set default requests and limits for containers that do not specify them, preventing BestEffort pods from slipping through when a developer forgets the resources field.

```yaml
// ✅ Defaults plus min/max bounds for any container without resources
apiVersion: v1
kind: LimitRange
metadata: {name: default-limits, namespace: production}
spec:
  limits:
  - type: Container
    default: {cpu: 500m, memory: 256Mi}
    defaultRequest: {cpu: 100m, memory: 128Mi}
    max: {cpu: "2", memory: 1Gi}
    min: {cpu: 50m, memory: 64Mi}
```

```yaml
// ❌ Namespace relying on every developer to set resources by hand
containers:
- name: api
  image: api:1.0
```
