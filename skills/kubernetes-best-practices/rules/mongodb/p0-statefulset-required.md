---
priority: P0
category: mongodb
---

# Deploy MongoDB as a StatefulSet

**Do**: Use a `StatefulSet` for MongoDB deployments to guarantee stable pod names, ordered deployment, and persistent identity for replica set members.

**Avoid**: Deploying MongoDB as a `Deployment`, which loses stable network identities and breaks replica set member discovery.

**Example**:
```yaml
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: mongodb
spec:
  serviceName: mongodb
  replicas: 3
  selector:
    matchLabels:
      app.kubernetes.io/name: mongodb
  template:
    metadata:
      labels:
        app.kubernetes.io/name: mongodb
    spec:
      containers:
        - name: mongod
          image: mongo:7.0
          ports:
            - containerPort: 27017
              name: mongodb
```
