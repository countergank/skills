// cdk8s Construct Template — Production Deployment with Security Defaults
// This is a structural template (not runnable as-is) demonstrating
// resource limits, probes, and securityContext defaults for cdk8s.

import { Construct } from 'constructs';
import * as k8s from 'cdk8s';
import * as plus from 'cdk8s-plus-28';

export interface ProductionDeploymentProps {
  name: string;
  image: string;
  port: number;
  replicas?: number;
  cpuRequest?: string;
  cpuLimit?: string;
  memoryRequest?: string;
  memoryLimit?: string;
  healthPath?: string;
  runAsUser?: number;
  labels?: Record<string, string>;
}

export class ProductionDeployment extends Construct {
  public readonly deployment: plus.Deployment;
  public readonly service: plus.Service;

  constructor(scope: Construct, id: string, props: ProductionDeploymentProps) {
    super(scope, id);

    const {
      name,
      image,
      port,
      replicas = 2,
      cpuRequest = '100m',
      cpuLimit = '500m',
      memoryRequest = '128Mi',
      memoryLimit = '256Mi',
      healthPath = '/health',
      runAsUser = 1000,
      labels = {},
    } = props;

    const defaultLabels = {
      'app.kubernetes.io/name': name,
      'app.kubernetes.io/managed-by': 'cdk8s',
      ...labels,
    };

    // Deployment with security defaults
    this.deployment = new plus.Deployment(this, 'Deployment', {
      replicas,
      selector: name,
      metadata: { labels: defaultLabels },
    });

    const container = this.deployment.addContainer({
      name,
      image,
      portNumber: port,
      // Resource requests and limits (P0)
      cpu: {
        request: k8s.Quantity.fromString(cpuRequest),
        limit: k8s.Quantity.fromString(cpuLimit),
      },
      memory: {
        request: k8s.Quantity.fromMebibytes(parseInt(memoryRequest)),
        limit: k8s.Quantity.fromMebibytes(parseInt(memoryRequest)),
      },
      // Health probes (P0 reliability)
      readiness: plus.Probe.fromHttpGet(healthPath, {
        port,
        initialDelay: k8s.Duration.seconds(5),
        period: k8s.Duration.seconds(10),
      }),
      liveness: plus.Probe.fromHttpGet('/health/live', {
        port,
        initialDelay: k8s.Duration.seconds(15),
        period: k8s.Duration.seconds(20),
      }),
      // Security context (P0 security)
      securityContext: {
        ensureNonRoot: true,
        readOnlyRootFilesystem: true,
        privileged: false,
        allowPrivilegeEscalation: false,
        user: runAsUser,
        capabilities: {
          drop: ['ALL'],
        },
      },
      // Logging (P0 observability)
      // Containers should log to stdout/stderr — no file logging
    });

    // Revision history limit (P2 reliability)
    this.deployment.metadata.addLabel(
      'app.kubernetes.io/version',
      image.split(':').pop() || 'latest'
    );

    // Service
    this.service = new plus.Service(this, 'Service', {
      selector: this.deployment,
      ports: [{ port, targetPort: port }],
      metadata: {
        labels: {
          ...defaultLabels,
          'app.kubernetes.io/component': 'service',
        },
      },
    });
  }
}
