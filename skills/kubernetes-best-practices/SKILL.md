---
name: kubernetes-best-practices
description: "Trigger: Kubernetes, k8s, cdk8s, Deployment, Service, Ingress, StatefulSet, NetworkPolicy, SealedSecret, ServiceMonitor, infrastructure/**."
license: MIT
metadata:
  author: countergank
  version: "1.0.0"
---

## When to Apply

Activate when authoring, reviewing, or modifying Kubernetes manifests, Helm charts, cdk8s constructs, or any infrastructure-as-code targeting `infrastructure/**`. Covers security hardening, resource management, reliability patterns, observability, naming conventions, MongoDB on K8s, and anti-pattern avoidance.

## Rule Categories by Priority

| Priority | Category | Count | Key Rules |
|----------|----------|-------|-----------|
| P0 | security | 5 | runAsNonRoot, readOnlyRootFS, drop capabilities, no privilege escalation, no host namespace sharing |
| P0 | resource-management | 4 | requests, limits, CPU limits, memory limits |
| P0 | reliability | 4 | readiness probe, liveness probe, replicas >= 2, PDB |
| P0 | observability | 3 | ServiceMonitor labels, pod scrape annotations, container logging |
| P0 | naming-labels | 3 | app.kubernetes.io/name, app.kubernetes.io/instance, namespace naming |
| P0 | mongodb | 3 | Persistent storage, StatefulSet required, auth enabled |
| P0 | anti-patterns | 3 | No latest tag, no privileged, no root user |
| P1 | security | 4 | seccomp profile, network policies, automount service token, pod security admission |
| P1 | resource-management | 2 | CPU/memory ratio, HPA configured |
| P1 | reliability | 3 | startup probe, termination grace period, topology spread |
| P1 | observability | 4 | structured logging, dashboard labels, alert rules, tracing context |
| P1 | naming-labels | 3 | component label, part-of label, managed-by label |
| P1 | mongodb | 3 | backup schedule, anti-affinity, TLS required |
| P1 | anti-patterns | 2 | no default namespace, missing probes |
| P2 | security | 1 | pod security admission (advisory) |
| P2 | resource-management | 1 | limit ranges |
| P2 | reliability | 1 | revision history limit |
| P2 | observability | 1 | cost allocation |
| P2 | naming-labels | 1 | version label |
| P2 | mongodb | 2 | arbiter pattern, connection pooling |
| P3 | anti-patterns | 1 | no image digest (advisory) |

**Totals**: 53 rules — 22 P0 + 19 P1 + 11 P2 + 1 P3 across 7 categories

## Quick Reference

| ID | Decision | Option A | Option B | When to choose |
|----|----------|----------|----------|----------------|
| `sec-001` | Root access | runAsNonRoot: true | runAsUser: 0 | Always non-root; use unprivileged base images |
| `sec-002` | Filesystem | readOnlyRootFS + emptyDir | Writable rootFS | Read-only always; tmp volumes for writable paths |
| `res-001` | Resources | requests + limits set | No resources defined | Always define both; missing = BestEffort (P0 violation) |
| `rel-001` | Probes | liveness + readiness | No probes | Both mandatory; add startup for slow-init containers |
| `obs-001` | Metrics | ServiceMonitor + annotations | Manual scraping | Use ServiceMonitor with proper labels |
| `lbl-001` | Labels | app.kubernetes.io/* set | No labels | Always set name, instance, version at minimum |
| `mdb-001` | MongoDB storage | PVC with Retain | emptyDir or Delete | StatefulSet + Retain for data durability |
| `anti-001` | Image tags | Specific semver tag | latest or no tag | Always pin versions; latest = unpredictable deploys |

## How to Use

1. **Agent loads this SKILL.md first** — the priority table identifies which categories apply to the current task.
2. **Navigate `rules/<category>/` by priority** — start with `p0-*.md` files (always loaded), then `p1-*.md` when context involves advanced security, observability, or reliability.
3. **Each rule file is self-contained** — read the Do/Avoid/Example, apply the pattern, move on. No need to load all files.
4. **Reference `references/`** for upstream standards summaries (PSS, recommended labels, Polaris defaults).
5. **Reference `assets/` templates** when scaffolding new K8s resources or cdk8s constructs.

## References

- [Pod Security Standards](references/pod-security-standards.md) — Privileged, Baseline, Restricted profiles
- [Recommended Labels](references/recommended-labels.md) — kubernetes.io recommended labels
- [Polaris Default Checks](references/polaris-default.yaml) — Fairwinds Polaris 9.x default configuration

## Assets

- `assets/cdk8s-construct.ts` — cdk8s Deployment + Service + Ingress construct with defaults
- `assets/network-policy.yaml` — Default-deny ingress/egress with explicit allow rules
- `assets/sealed-secret-example.yaml` — Bitnami SealedSecret pattern for sensitive data
- `assets/service-monitor.yaml` — Prometheus ServiceMonitor for metrics scraping
- `assets/mongodb-statefulset.yaml` — Production MongoDB StatefulSet with PDB, TLS, backup
