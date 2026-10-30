---
name: kubernetes-best-practices
description: "Trigger: Kubernetes, k8s, cdk8s, Deployment, Service, Ingress, StatefulSet, NetworkPolicy, SealedSecret, ServiceMonitor, infrastructure/**, manifiestos, cluster, Helm. Production Kubernetes standard for agents and humans: eight domain files covering security hardening, resource sizing, reliability, observability, naming and labels, MongoDB on Kubernetes, the anti-patterns that never ship, and how each decision is expressed in cdk8s-plus constructs. Úsala siempre que escribas, revises o modifiques manifiestos, Helm charts o constructs de cdk8s; léela antes de la primera línea de YAML y abre el archivo de dominio que corresponda a lo que estás creando."
license: MIT
permissions:
  - read-files
  - write-files
metadata:
  author: countergank
  version: "2.0.0"
---

Production Kubernetes standard. Eight domain files; each rule states one decision with one ✅/❌ pair. Read the file that matches the resource you are about to write.

| File | Read it when | Why |
|------|--------------|-----|
| `rules/security.md` | Writing a pod spec or a namespace policy | Non-root, dropped capabilities, read-only root fs, seccomp, network policies, RBAC, SealedSecrets, Pod Security Admission |
| `rules/resource-management.md` | Sizing containers or a namespace | Requests and limits, the limit-to-request ratio, HPA, ResourceQuota, LimitRange |
| `rules/reliability.md` | Making a workload survive drains and rollouts | Three probes, replicas, PodDisruptionBudget, spreading, priority, grace period, digest pinning |
| `rules/observability.md` | Wiring logs, metrics, alerts or traces | Structured stdout logs, scrape annotations, ServiceMonitor selectors, SLO alerts, trace context |
| `rules/naming-labels.md` | Naming or labelling any object | The `app.kubernetes.io/*` set, namespace naming, selector consistency |
| `rules/mongodb.md` | Deploying MongoDB | Auth, persistent storage, StatefulSet, backups, TLS, cache sizing, replica set shape |
| `rules/anti-patterns.md` | Before shipping a manifest | `emptyDir` for state, `hostPath`, `NodePort` |
| `rules/cdk8s.md` | The repository authors with cdk8s | Build on cdk8s-plus constructs instead of raw Kube objects, and how each domain decision maps to the construct's vocabulary |
| `assets/` | Scaffolding a resource | cdk8s construct, NetworkPolicy, ServiceMonitor, SealedSecret and MongoDB StatefulSet templates |
| `references/` | Checking upstream standards | Pod Security Standards, recommended labels, Fairwinds Polaris default checks |

MongoDB rules apply only to that workload; the other six domains apply to every manifest.

## Choosing the authoring path

This standard covers both ways of producing the same objects: plain YAML manifests, and cdk8s TypeScript constructs (`assets/cdk8s-construct.ts`).

Read the repository before writing. A `cdk8s.yaml`, an `imports/` directory, or `cdk8s-plus` in `package.json` means cdk8s; YAML under `manifests/`, `deploy/`, or `helm/` means plain manifests. Follow the path the repository already uses, even when the task does not name it, and say which path you took. When the repository shows neither, state the assumption and continue; ask only when the choice changes what you can deliver.
