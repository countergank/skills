# Security — Priority P0–P2

Read this file whenever you create or modify pod specs, RBAC, network policy, or secret manifests, so workloads stay non-root, least-privilege, and free of credentials in Git.

## P0 — Run containers as non-root

Set `securityContext.runAsNonRoot: true` with a non-zero `runAsUser` in the pod or container security context, and build on images that ship a non-root user such as `nginx:unprivileged`, `bitnami/*`, `distroless`, or `alpine`.

```yaml
# ✅ Non-root enforced at pod level with explicit IDs
securityContext:
  runAsNonRoot: true
  runAsUser: 1000
  runAsGroup: 3000
  fsGroup: 2000
```

```yaml
# ❌ Running as UID 0: a compromise gives full container control
image: myregistry/api:2.0.0
```

## P0 — Drop all capabilities

Drop `ALL` Linux capabilities and add back only the specific ones the container needs, such as `NET_BIND_SERVICE` for ports below 1024; the default capability set includes dangerous capabilities like `SYS_ADMIN` and `NET_RAW`.

```yaml
# ✅ Drop everything, add back only what is needed
securityContext:
  capabilities:
    drop: ["ALL"]
    add: ["NET_BIND_SERVICE"]
```

```yaml
# ❌ Default capability set keeps SYS_ADMIN and NET_RAW
securityContext: {}
```

## P0 — Disable privilege escalation

Set `allowPrivilegeEscalation: false` so child processes cannot gain more privileges than the parent, closing the SUID-binary path to root inside the container.

```yaml
# ✅ Escalation explicitly denied
securityContext: { allowPrivilegeEscalation: false }
```

```yaml
# ❌ SUID binaries can elevate to root
securityContext: { allowPrivilegeEscalation: true }
```

## P0 — Use a read-only root filesystem

Set `readOnlyRootFilesystem: true` and back the paths that require write access, such as `/tmp` and `/var/run`, with `emptyDir` volumes.

```yaml
# ✅ Immutable root, writable paths mounted explicitly
securityContext:
  readOnlyRootFilesystem: true
volumeMounts:
  - { name: tmp, mountPath: /tmp }
  - { name: var-run, mountPath: /var/run }
```

```yaml
# ❌ Writable root lets attackers replace binaries
securityContext: { readOnlyRootFilesystem: false }
```

## P0 — Keep host namespaces off and containers unprivileged

Omit `hostNetwork`, `hostPort`, and `hostPID` or set them to `false`, and never run a container with `privileged: true` — most workloads need zero elevated privileges.

```yaml
# ✅ Host namespaces off; Services replace hostPort
hostNetwork: false
hostPID: false
```

```yaml
# ❌ Privileged mode bypasses all container isolation
securityContext: { privileged: true }
```

## P1 — Disable service account token automount

Set `automountServiceAccountToken: false` on pods or service accounts unless the container explicitly needs access to the Kubernetes API.

```yaml
# ✅ No API credentials mounted by default
spec:
  automountServiceAccountToken: false
```

```yaml
# ❌ Token mounted in every pod, exploitable on compromise
automountServiceAccountToken: true
```

## P1 — Set a seccomp profile

Set a seccomp profile of type `RuntimeDefault` or a custom profile in the pod or container `securityContext` to restrict the system calls available to the container.

```yaml
# ✅ Kernel syscalls restricted by default
securityContext:
  seccompProfile:
    type: RuntimeDefault
```

```yaml
# ❌ Unconfined allows unrestricted kernel syscalls
securityContext:
  seccompProfile:
    type: Unconfined
```

## P1 — Define network policies

Create `NetworkPolicy` resources that restrict ingress and egress for each namespace or workload, following least privilege for pod-to-pod communication; start from a default-deny ingress policy in every production namespace.

```yaml
# ✅ Default-deny ingress for every pod in the namespace
kind: NetworkPolicy
spec:
  podSelector: {}
  policyTypes:
    - Ingress
```

```yaml
# ❌ No policy selects this pod, so all traffic is allowed
containers:
  - name: api
```

## P1 — Scope RBAC to least privilege

Create a dedicated `ServiceAccount` per workload — never use the default one — with a `Role` scoped to only the resources and verbs the application actually needs.

```yaml
# ✅ Role scoped to exactly the resources and verbs needed
rules:
  - apiGroups: [""]
    resources: ["configmaps"]
    verbs: ["get", "list"]
```

```yaml
# ❌ cluster-admin bound to an app workload
roleRef:
  kind: ClusterRole
  name: cluster-admin
```

## P1 — Store secrets as SealedSecrets

Use Bitnami SealedSecrets to encrypt Kubernetes Secrets for safe storage in Git, running `kubeseal` before committing.

```yaml
# ✅ kubeseal output is safe to commit
apiVersion: bitnami.com/v1alpha1
kind: SealedSecret
spec:
  encryptedData:
    MONGODB_URI: AgB4xqT2...encrypted_base64...
```

```yaml
# ❌ Plaintext Secret in version control, even in private repos
stringData:
  MONGODB_PASSWORD: "s3cret"
```

## P2 — Enforce Pod Security Admission

Configure the Pod Security Admission controller at the namespace level with the `pod-security.kubernetes.io/enforce` label set to `baseline` or `restricted`.

```yaml
# ✅ Restricted standard enforced on the namespace
metadata:
  labels:
    pod-security.kubernetes.io/enforce: restricted
```

```yaml
# ❌ No PSA labels, so privileged pods are admitted
metadata:
  name: production
```
