---
priority: P1
category: mongodb
---

# Configure MongoDB Backup Schedule

**Do**: Define a `CronJob` or use the MongoDB Operator's backup schedule to create regular backups of the database, storing them in a durable external location (e.g., S3, GCS).

**Avoid**: Running MongoDB in production without automated backups, relying on manual snapshots or hoping the cloud provider's disk snapshots are sufficient for point-in-time recovery.

**Example**:
```yaml
apiVersion: batch/v1
kind: CronJob
metadata:
  name: mongodb-backup
spec:
  schedule: "0 2 * * *"
  jobTemplate:
    spec:
      template:
        spec:
          containers:
            - name: mongodump
              image: mongo:7.0
              command:
                - mongodump
                - --host=mongodb-0.mongodb-headless:27017
                - --authenticationDatabase=admin
                - --username=$(MONGO_USER)
                - --password=$(MONGO_PASSWORD)
                - --archive=/backup/mongodump-$(date +%Y%m%d).gz
                - --gzip
              env:
                - name: MONGO_USER
                  valueFrom:
                    secretKeyRef:
                      name: mongodb-credentials
                      key: username
                - name: MONGO_PASSWORD
                  valueFrom:
                    secretKeyRef:
                      name: mongodb-credentials
                      key: password
          restartPolicy: OnFailure
```
