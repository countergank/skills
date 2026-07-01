# Pod Security Standards (PSS) Summary

Kubernetes Pod Security Standards define three progressively restrictive profiles for pod security. These are enforced via namespace-level labels using the Pod Security Admission controller.

Source: [kubernetes.io/docs/concepts/security/pod-security-standards](https://kubernetes.io/docs/concepts/security/pod-security-standards/)

## Privileged

Unrestricted policy, providing the widest possible level of permissions.

- **No restrictions** on pod specifications
- Allows privileged containers, host namespaces, capabilities, and all volume types
- Intended for system-level workloads that require full node access
- **Use case**: kube-system, monitoring agents (e.g., node-exporter), CNI plugins

## Baseline

Minimally restrictive policy, preventing known privilege escalations.

### Restrictions

- Host namespaces (`hostNetwork`, `hostPID`, `hostIPC`) — **disallowed**
- Host ports — **disallowed**
- Privileged containers — **disallowed**
- Capabilities exceeding the default set — **disallowed** (only default allowed set)
- `hostPath` volumes — **disallowed**
- Seccomp profile — must not be explicitly set to `Unconfined`
- AppArmor, SELinux, seccomp — restricted profiles only

### What's Still Allowed

- Running as root
- Writable root filesystem
- Adding default capabilities
- Volume types except `hostPath`
- **Use case**: Most workloads that don't need special host access

## Restricted

Heavily restricted policy, following current pod hardening best practices.

### Includes All Baseline Restrictions Plus

- `securityContext.runAsNonRoot: true` — **required**
- `securityContext.allowPrivilegeEscalation: false` — **required**
- Capabilities — must drop `ALL`, may add only `NET_BIND_SERVICE`
- Seccomp profile — must be `RuntimeDefault` or `Localhost`
- `securityContext.seLinuxOptions` — restricted to allowed types
- Volume types — restricted to: `configMap`, `csi`, `downwardAPI`, `emptyDir`, `ephemeral`, `persistentVolumeClaim`, `projected`, `secret`

### Target

- **Use case**: Production workloads, especially multi-tenant clusters
- **Goal**: Containers run as non-root, with minimal capabilities, no privilege escalation

## Enforcement Labels

Apply to namespaces via labels:

```yaml
apiVersion: v1
kind: Namespace
metadata:
  name: my-namespace
  labels:
    pod-security.kubernetes.io/enforce: restricted      # Reject violating pods
    pod-security.kubernetes.io/enforce-version: latest   # Track PSS version
    pod-security.kubernetes.io/audit: restricted         # Log violations (no reject)
    pod-security.kubernetes.io/audit-version: latest
    pod-security.kubernetes.io/warn: restricted          # Warn on create (no reject)
    pod-security.kubernetes.io/warn-version: latest
```

## Migration Path

1. **Start with `baseline`** — catch obvious security issues without breaking existing workloads
2. **Move to `restricted`** — enforce non-root, drop capabilities, seccomp defaults
3. **Use `audit` and `warn` first** — observe violations before enforcing
