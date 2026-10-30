# Reliability — Priority P0

Read this file when the task touches the uptime and recovery of a Kubernetes workload: probes, replica counts, disruption budgets, scheduling spread, priority, graceful shutdown, image pinning, and rollback history.

## P0 — Configure liveness, readiness, and startup probes on every container

Define a `readinessProbe`, a `livenessProbe`, and a `startupProbe` on every container so Kubernetes sends traffic only to pods that are ready to serve requests, restarts pods that are stuck or deadlocked, and waits out slow initialization before running liveness checks. Use separate endpoints for liveness and readiness: liveness checks whether the process is alive, readiness whether it can accept traffic, for example while it is still loading data or waiting for dependencies. Use a `startupProbe` instead of a long `initialDelaySeconds` on the liveness probe, which delays failure detection for the pod's whole lifetime even after startup completes.

```yaml
# ✅ Three probes on separate health endpoints; startup gates the liveness checks
readinessProbe: { httpGet: { path: /healthz/ready, port: 8080 }, periodSeconds: 10, failureThreshold: 3 }
livenessProbe: { httpGet: { path: /healthz/live, port: 8080 }, periodSeconds: 20, failureThreshold: 3 }
startupProbe: { httpGet: { path: /healthz/startup, port: 8080 }, failureThreshold: 30, periodSeconds: 10 }
```
```yaml
# ❌ No probes: failures go undetected and traffic keeps flowing to unhealthy pods
containers:
  - name: api
    image: myregistry/api:1.0.0
```

## P0 — Run at least two replicas for production workloads

Set `replicas: 2` or higher on every production workload so availability survives node failures, rolling updates, and maintenance, and pair the count with a rolling update strategy that never drops capacity during the rollout. A single production replica is a single point of failure that takes downtime on every deployment.

```yaml
# ✅ Three replicas with a rolling update that keeps full capacity
kind: Deployment
spec:
  replicas: 3
  strategy:
    rollingUpdate: { maxSurge: 1, maxUnavailable: 0 }
```
```yaml
# ❌ One production replica: a node failure or a rollout takes the service down
kind: Deployment
spec:
  replicas: 1
```

## P0 — Define a PodDisruptionBudget for every production workload

Define a `PodDisruptionBudget` for every production workload so voluntary disruptions from node drains, cluster upgrades, and autoscaling events cannot evict all replicas at once. Without one, cluster operations may take down every replica simultaneously.

```yaml
# ✅ One replica stays available during voluntary disruptions
kind: PodDisruptionBudget
spec:
  minAvailable: 1
  selector:
    matchLabels: { app.kubernetes.io/name: api-server }
```
```yaml
# ❌ Workload with no PodDisruptionBudget: a drain can evict every replica
kind: Deployment
metadata: { name: api-server }
spec:
  replicas: 2
```

## P1 — Spread replicas across nodes and zones

Spread replicas across failure domains so one node or zone failure cannot take down the whole workload: `podAntiAffinity` with `preferredDuringSchedulingIgnoredDuringExecution` and `topologyKey: kubernetes.io/hostname` keeps replicas off the same node, `topologySpreadConstraints` with `maxSkew: 1` on `topology.kubernetes.io/zone` guarantees balanced distribution across zones, and stateful databases such as MongoDB use `requiredDuringSchedulingIgnoredDuringExecution` so each member runs on its own node. Anti-affinity alone prevents co-location but does not guarantee balanced distribution across failure domains.

```yaml
# ✅ Node anti-affinity plus zone spread on the same workload
spec:
  affinity:
    podAntiAffinity:
      preferredDuringSchedulingIgnoredDuringExecution:
        - weight: 100
          podAffinityTerm:
            labelSelector: { matchLabels: { app.kubernetes.io/name: api-server } }
            topologyKey: kubernetes.io/hostname
  topologySpreadConstraints:
    - maxSkew: 1
      topologyKey: topology.kubernetes.io/zone
      whenUnsatisfiable: DoNotSchedule
      labelSelector: { matchLabels: { app.kubernetes.io/name: api-server } }
```
```yaml
# ❌ Replicas with no affinity or spread constraints may co-locate on one node
spec:
  replicas: 3
  template:
    spec:
      affinity: {}
```

## P1 — Assign priority classes to production workloads

Set `priorityClassName` on production Deployments and StatefulSets so critical workloads keep scheduling priority and are not evicted before lower-priority pods. On the default priority of 0, production services may be preempted by any higher-priority pod.

```yaml
# ✅ PriorityClass plus the production workload referencing it
kind: PriorityClass
metadata: { name: production-high }
value: 1000000
globalDefault: false
---
kind: Deployment
spec:
  template:
    spec:
      priorityClassName: production-high
```
```yaml
# ❌ No priorityClassName: the workload is preempted at default priority 0
kind: Deployment
spec:
  template:
    spec:
      containers:
        - name: api-server
```

## P1 — Set a termination grace period that fits the drain time

Configure `terminationGracePeriodSeconds` so the application has enough time to finish in-flight requests, drain connections, and shut down gracefully before Kubernetes sends `SIGKILL`, and add a `preStop` hook that covers the drain window. The default 30-second grace period is too short for workloads that need longer to drain, and 0 risks data loss and incomplete transactions.

```yaml
# ✅ Grace period sized to the drain, with a preStop hook
spec:
  terminationGracePeriodSeconds: 60
  containers:
    - name: api-server
      image: myapp:1.2.3
      lifecycle:
        preStop:
          exec: { command: ["sh", "-c", "sleep 10 && curl -X POST http://localhost:8080/drain"] }
```
```yaml
# ❌ Grace period of 0: SIGKILL lands right after SIGTERM, in-flight requests lost
spec:
  terminationGracePeriodSeconds: 0
```

## P1 — Pin production images by digest

Pin every production image to its SHA256 digest, `image: nginx@sha256:...`, so each pull returns the same immutable, auditable bytes even if a semver tag is retagged, and keep the version tag as a comment for human readability. Use `latest` or an omitted tag nowhere in production: it is mutable and unpredictable, breaks reproducibility and rollback guarantees, and forces an implicit `imagePullPolicy: Always` with extra registry traffic; for versioned tags set `imagePullPolicy: IfNotPresent`, reserving `Always` for a mutable tag that cannot be avoided outside production.

```yaml
# ✅ Digest pin with the tag as a comment, IfNotPresent for versioned tags
containers:
  - name: api
    image: myregistry/api@sha256:3a7bd3e2360a3d292b50e5e0f8c6e8d7f9a1b2c3d4e5f6a7b8c9d0e1f2a3b4c5
    # myregistry/api:1.4.2 — human-readable tag
    imagePullPolicy: IfNotPresent
```
```yaml
# ❌ latest with no explicit pull policy: mutable image and forced Always pulls
containers:
  - name: api
    image: myregistry/api:latest
```

## P2 — Keep a bounded revision history for rollbacks

Set `revisionHistoryLimit` on Deployments and StatefulSets to control how many old ReplicaSets are retained; a value of 3-5 is sufficient for rollbacks without accumulating garbage. The default 10 wastes etcd storage, and 0 disables rollbacks entirely.

```yaml
# ✅ Five old ReplicaSets retained for rollbacks
kind: Deployment
spec:
  replicas: 3
  revisionHistoryLimit: 5
```
```yaml
# ❌ revisionHistoryLimit 0: old ReplicaSets deleted, rollback impossible
kind: Deployment
spec:
  revisionHistoryLimit: 0
```
