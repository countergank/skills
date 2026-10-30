# Anti-Patterns — Priority P0

Read this file before shipping any workload to production: the three patterns here never ship to a production cluster.

## P0 — Store stateful data on PersistentVolumeClaims, never emptyDir

Give every workload whose data must survive pod restarts, evictions, or node failures a `PersistentVolumeClaim`, and give StatefulSets their storage through `volumeClaimTemplates` so each replica owns its own volume. `emptyDir` is erased together with the pod, so it is only fit for scratch space that is safe to lose. Exception: ephemeral caches or shared temp files that the application can rebuild are acceptable in `emptyDir`.

```yaml
# ✅ StatefulSet storage that survives rescheduling
volumeClaimTemplates:
- metadata:
    name: data
  spec:
    accessModes: [ReadWriteOnce]
    resources:
      requests:
        storage: 20Gi
```

```yaml
# ❌ Database state in emptyDir is lost with the pod
containers:
- name: mongodb
  volumeMounts:
  - name: data
    mountPath: /data/db
volumes:
- name: data
  emptyDir: {}
```

## P0 — Use PersistentVolumeClaims instead of hostPath volumes

Back persistent storage with a `PersistentVolumeClaim` and a `StorageClass` so volumes stay portable across nodes and survive pod rescheduling. A `hostPath` volume binds the data to one specific node and punches a hole into the node filesystem, so containers can read and write host paths they should never reach. Exception: a DaemonSet that genuinely needs a node-local file, such as a log shipper reading `/var/log`, is the only acceptable hostPath use.

```yaml
# ✅ Portable storage backed by a StorageClass
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: data-pvc
spec:
  accessModes: [ReadWriteOnce]
  resources:
    requests:
      storage: 10Gi
  storageClassName: standard
```

```yaml
# ❌ hostPath pins data to one node and exposes the host filesystem
volumes:
- name: data
  hostPath:
    path: /var/lib/data
```

## P0 — Expose services through ClusterIP and Ingress, never NodePort

Use `ClusterIP` for service-to-service traffic and an `Ingress` controller for external access, so TLS termination, routing, and authentication stay in one place. `LoadBalancer` is reserved for the case where the cloud provider manages it directly. `type: NodePort` bypasses the Ingress controller, exposes node IPs directly, and multiplies security and routing complexity.

```yaml
# ✅ Internal ClusterIP service fronted by an Ingress
apiVersion: v1
kind: Service
metadata:
  name: api-server
spec:
  type: ClusterIP
  ports:
  - port: 80
```

```yaml
# ❌ NodePort publishes the service on every node IP
apiVersion: v1
kind: Service
metadata:
  name: api-server
spec:
  type: NodePort
  ports:
  - port: 80
    nodePort: 30080
```
