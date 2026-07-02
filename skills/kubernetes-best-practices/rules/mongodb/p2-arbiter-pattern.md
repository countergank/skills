---
priority: P2
category: mongodb
---

# Avoid Arbiter Pattern in Production

**Do**: Deploy replica sets with an odd number of data-bearing members (3, 5, or 7) instead of using arbiters. Each member holds data and participates in elections.

**Avoid**: Using MongoDB arbiters in production Kubernetes deployments. Arbiters add complexity without data redundancy, and in K8s environments where pods can be rescheduled, an arbiter provides no real high-availability benefit.

**Example**:
```yaml
# Preferred: 3 data-bearing members (no arbiter)
apiVersion: mongodbcommunity.mongodb.com/v1
kind: MongoDBCommunity
metadata:
  name: mongodb-replica-set
spec:
  members: 3
  type: ReplicaSet
  version: "7.0.5"
  security:
    authentication:
      modes: ["SCRAM"]
# Avoid: adding an arbiter member
# spec:
#   members: 2
#   arbiters: 1  # Do not use in production K8s
```
