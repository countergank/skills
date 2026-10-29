# Security — Priority P0–P2

Read this file whenever you create or modify pod specs, RBAC, network policy, or secret manifests, so workloads stay non-root, least-privilege, and free of credentials in Git.

## P0 — Run containers as non-root
Set `securityContext.runAsNonRoot: true` with a non-zero `runAsUser` in the pod or container security context. Build on images that ship a non-root user such as `nginx:unprivileged`, `bitnami/*`, `distroless`, or `alpine`.
```yaml
# ✅ Non-root enforced at pod level with explicit IDs
spec:
  securityContext: { runAsNonRoot: true, runAsUser: 1000, runAsGroup: 3000, fsGroup: 2000 }
```
```yaml
# ❌ Running as UID 0: a compromise gives full container control
spec:
  containers:
    - { name: api, image: myregistry/api:2.0.0, securityContext: { runAsUser: 0 } }
```

## P0 — Drop all capabilities
Drop `ALL` Linux capabilities. Add back only what the container needs, such as `NET_BIND_SERVICE` for ports below 1024. The default set keeps dangerous capabilities like `SYS_ADMIN` and `NET_RAW`.
```yaml
# ✅ Drop everything, add back only what is needed
spec:
  containers:
    - name: api
      securityContext:
        capabilities: { drop: ["ALL"], add: ["NET_BIND_SERVICE"] }
```
```yaml
# ❌ Default capability set keeps SYS_ADMIN and NET_RAW
spec:
  containers:
    - { name: api, securityContext: {} }
```

## P0 — Disable privilege escalation
Set `allowPrivilegeEscalation: false` in the container security context.
```yaml
# ✅ Escalation explicitly denied
spec:
  containers:
    - name: api
      securityContext:
        allowPrivilegeEscalation: false
```
```yaml
# ❌ SUID binaries can elevate to root
spec:
  containers:
    - name: api
      securityContext:
        allowPrivilegeEscalation: true
```

## P0 — Use a read-only root filesystem
Set `readOnlyRootFilesystem: true`. Back write paths such as `/tmp` and `/var/run` with `emptyDir` volumes.
```yaml
# ✅ Immutable root, writable paths mounted explicitly
spec:
  containers:
    - name: api
      securityContext: { readOnlyRootFilesystem: true }
      volumeMounts:
        - { name: tmp, mountPath: /tmp }
        - { name: var-run, mountPath: /var/run }
  volumes: [{ name: tmp, emptyDir: {} }, { name: var-run, emptyDir: {} }]
```
```yaml
# ❌ Writable root lets attackers replace binaries
spec:
  containers:
    - { name: api, securityContext: { readOnlyRootFilesystem: false } }
```

## P0 — Keep host namespaces off and containers unprivileged
Omit `hostNetwork`, `hostPort`, and `hostPID` or set them to `false`. Never run a container with `privileged: true`.
```yaml
# ✅ Host namespaces off; Services replace hostPort
spec:
  hostNetwork: false
  hostPID: false
  hostIPC: false
  containers:
    - name: api
```
```yaml
# ❌ Privileged mode bypasses all container isolation
spec:
  containers:
    - name: api
      securityContext: { privileged: true }
```

## P1 — Disable service account token automount
Set `automountServiceAccountToken: false` on pods or service accounts. Make an exception only when the container explicitly needs access to the Kubernetes API.
```yaml
# ✅ No API credentials mounted by default
spec:
  automountServiceAccountToken: false
  containers:
    - name: api
```
```yaml
# ❌ Token mounted in every pod, exploitable on compromise
spec:
  automountServiceAccountToken: true
  serviceAccountName: default
```

## P1 — Set a seccomp profile
Set `securityContext.seccompProfile.type` to `RuntimeDefault` or a custom profile, at the pod or container level.
```yaml
# ✅ Kernel syscalls restricted by default
spec:
  securityContext:
    seccompProfile: { type: RuntimeDefault }
```
```yaml
# ❌ Unconfined allows unrestricted kernel syscalls
spec:
  securityContext:
    seccompProfile: { type: Unconfined }
```

## P1 — Define network policies
Create `NetworkPolicy` resources restricting ingress and egress per namespace or workload. Start from a default-deny ingress policy in every production namespace.
```yaml
# ✅ Default-deny ingress for every pod in the namespace
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata: { name: default-deny }
spec:
  podSelector: {}
  policyTypes: [Ingress]
```
```yaml
# ❌ No policy selects this pod, so all traffic is allowed
kind: Pod
metadata: { name: api, labels: {} }
spec:
  containers:
    - name: api
```

## P1 — Scope RBAC to least privilege
Create a dedicated `ServiceAccount` per workload. Never use the default one. Scope its `Role` to only the resources and verbs the application actually needs.
```yaml
# ✅ A dedicated ServiceAccount and a Role scoped to what it needs
apiVersion: v1
kind: ServiceAccount
metadata: { name: api }
---
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
rules:
  - { apiGroups: [""], resources: ["configmaps"], verbs: ["get", "list"] }
```
```yaml
# ❌ cluster-admin bound to an app workload
roleRef: { kind: ClusterRole, name: cluster-admin }
subjects:
  - { kind: ServiceAccount, name: api }
```

## P1 — Store secrets as SealedSecrets
Use Bitnami SealedSecrets to encrypt Kubernetes Secrets for safe storage in Git. Run `kubeseal` before committing.
```yaml
# ✅ kubeseal output is safe to commit
apiVersion: bitnami.com/v1alpha1
kind: SealedSecret
spec: { encryptedData: { MONGODB_URI: AgB4xqT2...encrypted_base64... } }
```
```yaml
# ❌ Plaintext Secret in version control, even in private repos
apiVersion: v1
kind: Secret
stringData: { MONGODB_PASSWORD: "s3cret" }
```

## P2 — Enforce Pod Security Admission
Configure Pod Security Admission at the namespace level. Set the `pod-security.kubernetes.io/enforce` label to `baseline` or `restricted`.
```yaml
# ✅ Restricted standard enforced on the namespace
apiVersion: v1
kind: Namespace
metadata:
  labels: { pod-security.kubernetes.io/enforce: restricted }
```
```yaml
# ❌ No PSA labels, so privileged pods are admitted
apiVersion: v1
kind: Namespace
metadata: { name: production }
```
