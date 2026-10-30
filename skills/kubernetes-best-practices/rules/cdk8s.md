# cdk8s — Priority P0–P1

Read this file when the repository authors its Kubernetes resources with cdk8s instead of plain YAML. The other seven domains still apply: this one says how to express their decisions in the construct.

## P0 — Build the workload from cdk8s-plus, not from raw Kube objects

`plus.Deployment` and `addContainer` own the pod template, the selector and the defaults that the YAML domains spell out by hand. Reaching for `k8s.KubeDeployment` with a literal `spec` hands all of that back: no defaults, no selector wiring, and a diff that reads like YAML written in TypeScript. `assets/cdk8s-construct.ts` is the reference implementation and the shape to copy.

```typescript
// ✅ The construct owns the template, the selector and the defaults
const deploy = new plus.Deployment(this, 'Deployment', { replicas: 3, selector: name });
deploy.addContainer({ name, image, portNumber: port });
const svc = new plus.Service(this, 'Service', { selector: deploy, ports: [{ port, targetPort: port }] });
```

```typescript
// ❌ Raw Kube objects: every field the domains require is yours to remember
new k8s.KubeDeployment(this, 'Deployment', { spec: { replicas: 3, template: { spec: { containers } } } });
```

## P1 — Express each decision in the construct's vocabulary

The decisions do not change, the field names do. Map what the other domains require onto the construct:

| Decision | YAML domain | cdk8s-plus |
|---|---|---|
| Non-root, no escalation | `security.md` | `securityContext: { ensureNonRoot: true, user: 1000, allowPrivilegeEscalation: false }` |
| Read-only root, no capabilities | `security.md` | `securityContext: { readOnlyRootFilesystem: true, capabilities: { drop: ['ALL'] } }` |
| Requests and limits | `resource-management.md` | `cpu: { request: k8s.Quantity.fromString('100m'), limit: … }`, `memory: { request: k8s.Quantity.fromMebibytes(128), limit: … }` |
| Probes | `reliability.md` | `readiness` and `liveness: plus.Probe.fromHttpGet(path, { port, initialDelay, period })` |
| Labels and selector | `naming-labels.md` | `metadata: { labels }` with `deployment.metadata.addLabel(...)`, and `selector: deploy` on the Service |

What the construct does not model — `PodDisruptionBudget`, `NetworkPolicy`, `ServiceMonitor`, `SealedSecret` — keeps the YAML shape of its own domain until a construct exists. Do not invent props for them.

```typescript
// ✅ The security context carried in full, exactly as the domains state it
securityContext: { ensureNonRoot: true, user: 1000, readOnlyRootFilesystem: true,
  privileged: false, allowPrivilegeEscalation: false, capabilities: { drop: ['ALL'] } }
```

```typescript
// ❌ An empty security context: the pod keeps its default capabilities
securityContext: {}
```
