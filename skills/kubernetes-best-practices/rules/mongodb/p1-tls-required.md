---
priority: P1
category: mongodb
---

# Require MongoDB TLS

**Do**: Enable TLS for MongoDB connections using `--tlsMode requireTLS` and configure certificates via Kubernetes Secrets or cert-manager to encrypt data in transit between clients and the database.

**Avoid**: Running MongoDB with TLS disabled, which exposes credentials, queries, and data to network-level eavesdropping and man-in-the-middle attacks.

**Example**:
```yaml
containers:
  - name: mongod
    image: mongo:7.0
    args:
      - --tlsMode
      - requireTLS
      - --tlsCertificateKeyFile
      - /tls/tls.pem
      - --tlsCAFile
      - /tls/ca.crt
    volumeMounts:
      - name: tls-certs
        mountPath: /tls
        readOnly: true
volumes:
  - name: tls-certs
    secret:
      secretName: mongodb-tls
```
