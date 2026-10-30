# MongoDB — Priority P0

Read this file when the task deploys or operates MongoDB on Kubernetes.

## P0 — Enable authentication on every MongoDB instance

Require credentials for every connection by running mongod with `--auth` and injecting `MONGO_INITDB_ROOT_USERNAME` and `MONGO_INITDB_ROOT_PASSWORD` from a Secret.

```yaml
# ✅ Credentials from a Secret, mongod started with --auth
containers:
  - name: mongod
    image: mongodb/mongodb-community-server:7.0
    args: ["--auth"]
    env:
      - name: MONGO_INITDB_ROOT_USERNAME
        valueFrom: { secretKeyRef: { name: mongodb-credentials, key: username } }
```
```yaml
# ❌ No --auth and no credentials: unauthenticated access
containers:
  - name: mongod
    image: mongodb/mongodb-community-server:7.0
```

## P0 — Back MongoDB data volumes with Retain-reclaimed PVCs

Give data volumes PersistentVolumeClaims whose PersistentVolumes set `persistentVolumeReclaimPolicy: Retain`, so data survives pod rescheduling and StatefulSet teardown.

```yaml
# ✅ PVC with a Retain-backed volume
kind: PersistentVolumeClaim
metadata: { name: mongodb-data }
spec:
  accessModes: [ReadWriteOnce]
  storageClassName: standard
  resources:
    requests: { storage: 50Gi }
```
```yaml
# ❌ Delete reclaims the data when the claim goes away
kind: PersistentVolume
spec: { persistentVolumeReclaimPolicy: Delete }
```

## P0 — Deploy MongoDB as a StatefulSet

Run MongoDB as a StatefulSet so replica set members keep stable pod names, ordered deployment, and persistent network identity; a Deployment loses those and breaks member discovery. The shipped `assets/mongodb-statefulset.yaml` uses the MongoDBCommunity operator, which owns the StatefulSet.

```yaml
# ✅ StatefulSet gives stable pod identity
apiVersion: apps/v1
kind: StatefulSet
metadata: { name: mongodb }
spec:
  serviceName: mongodb
  replicas: 3
  selector: { matchLabels: { app.kubernetes.io/name: mongodb } }
```
```yaml
# ❌ Deployment loses stable network identity
apiVersion: apps/v1
kind: Deployment
metadata: { name: mongodb }
```

## P1 — Schedule automated backups to durable external storage

Create regular backups with a `CronJob` running `mongodump` (or the operator's backup schedule) and ship them to a durable external location such as S3 or GCS.

```yaml
# ✅ Nightly mongodump CronJob with Secret credentials
apiVersion: batch/v1
kind: CronJob
metadata: { name: mongodb-backup }
spec:
  schedule: "0 2 * * *"
  jobTemplate: { spec: { template: { spec: { containers: [{ name: mongodump, image: "mongodb/mongodb-community-server:7.0" }] } } } }
```
```yaml
# ❌ Manual snapshots are not point-in-time recovery
kind: CronJob
metadata: { name: none-defined }
```

## P1 — Require TLS for client connections

Encrypt data in transit with `--tlsMode requireTLS`, mounting the certificate key and CA from a Secret or cert-manager.

```yaml
# ✅ mongod requires TLS with certs from a Secret
containers:
  - name: mongod
    image: mongodb/mongodb-community-server:7.0
    args: ["--tlsMode", "requireTLS", "--tlsCertificateKeyFile", "/tls/tls.pem", "--tlsCAFile", "/tls/ca.crt"]
    volumeMounts: [{ name: tls-certs, mountPath: /tls, readOnly: true }]
volumes:
  - name: tls-certs
    secret: { secretName: mongodb-tls }
```
```yaml
# ❌ Plaintext connections expose credentials and data
containers:
  - name: mongod
    image: mongodb/mongodb-community-server:7.0
```

## P1 — Cap the WiredTiger cache at half the memory limit

Set `--wiredTigerCacheSizeGB` to a value ≤ 50% of the container memory limit, because MongoDB's default of 50% of system RAM ignores cgroup limits and the OOM killer terminates the process under pressure. Equal memory request and limit is deliberate for databases.

```yaml
# ✅ 2Gi cache under a 4Gi memory limit
containers:
  - name: mongodb
    image: mongodb/mongodb-community-server:7.0
    args: ["--wiredTigerCacheSizeGB=2"]
    resources: { limits: { memory: "4Gi" }, requests: { memory: "4Gi" } }
```
```yaml
# ❌ No cache setting: OOM killer wins under pressure
containers:
  - name: mongodb
    image: mongodb/mongodb-community-server:7.0
    resources: { limits: { memory: "4Gi" } }
```

## P2 — Use odd data-bearing members, never arbiters in production

Deploy replica sets with an odd number of data-bearing members (3, 5, or 7), each holding data and voting in elections; arbiters add complexity without data redundancy and give no real availability in rescheduled pods.

```yaml
# ✅ Three data-bearing members, no arbiter
apiVersion: mongodbcommunity.mongodb.com/v1
kind: MongoDBCommunity
metadata: { name: mongodb-replica-set }
spec:
  members: 3
  type: ReplicaSet
  version: "7.0.5"
  security: { authentication: { modes: ["SCRAM"] } }
```
```yaml
# ❌ Arbiter adds no data redundancy
spec:
  members: 2
  arbiters: 1
```

## P2 — Bound the connection pool on driver and server

Set `maxPoolSize` and `minPoolSize` on the driver against the server's `net.maxIncomingConnections` cap so pools stay bounded; default pool sizes or a new connection per request exhaust server connections and degrade every client.

```yaml
# ✅ Driver pool bounds plus a server-side cap
kind: ConfigMap
metadata: { name: mongodb-connection-config }
data:
  MONGODB_MAX_POOL_SIZE: "50"
  MONGODB_MIN_POOL_SIZE: "10"
  MONGODB_MAX_IDLE_TIME_MS: "30000"
  MONGODB_WAIT_QUEUE_TIMEOUT_MS: "5000"
```
```yaml
# ❌ Unbounded pool against an uncapped server
data:
  MONGODB_URI: "mongodb://mongodb-0.mongodb-headless:27017"
```

## P2 — Export Prometheus metrics with mongodb-exporter

Add a `percona/mongodb_exporter` sidecar exposing Prometheus-format metrics on port 9216 with `--collect-all`, so database health, query performance, and pool stats stay visible to monitoring.

```yaml
# ✅ Exporter sidecar with a named metrics port
containers:
  - { name: mongodb, image: "mongodb/mongodb-community-server:7.0" }
  - name: mongodb-exporter
    image: percona/mongodb_exporter:0.40
    args: ["--mongodb.uri=mongodb://localhost:27017", "--collect-all"]
    ports: [{ containerPort: 9216, name: metrics }]
```
```yaml
# ❌ No metrics export: monitoring stays blind
containers:
  - name: mongodb
    image: mongodb/mongodb-community-server:7.0
```
