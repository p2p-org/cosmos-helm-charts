# blch node helm chart

A Helm chart for deploying cosmos-sdk based node to be used as a standalone RPC node or a validator with an external remote signer.

The chart is inspired by the great work of [the Kubernetes cosmos-operator](https://github.com/strangelove-ventures/cosmos-operator) and the [cosmos node chart ](https://github.com/nodeify-eth/helm-charts/tree/main/charts/cosmos-node).

The chart currently supports most cosmos-sdk based chains, with plans to expand the usage for other types of chains.

## Overview

This chart deploys a complete node including:

- Statefulset for the node
- Optional sidecar with configmaps
- Ingress with configrable endpoints (RPC, gRPC, API, WS, etc)
- Optional HTTPRoute support for Gateway API (when `useGatewayAPI: true`)
- Optional sentry mode (remote signer is required and not included in this chart)
- Optional prometheus monitoring for:
  - Default CometBFT metrics
  - Latest block height compared to a given public RPC endpoint
  - Endpoint monitoring for the deployed RPC endpoint

## Prerequisites

- Helm 3.2.0+
- Ingress Controller (nginx) - **OR** Gateway API with Gateway resource (when using `useGatewayAPI: true`)
- Cert-manager (optional, for TLS)
- Prometheus blackbox exporter (optional, for monitoring)
- Prometheus json exporter (optional, for monitoring)

## Installation

1. Customize the values file as needed or create a new one, and install the chart (note that the node name will be taken from the helm release name)

```bash
helm install <release-name> . \
  --create-namespace \
  --namespace <namespace> \
  -f <values-file>
```

## Gateway API Support

This chart supports both traditional Ingress resources and Gateway API HTTPRoute resources. To use Gateway API:

1. Set `useGatewayAPI: true` in your values
2. Configure the Gateway details:
   ```yaml
   useGatewayAPI: true
   gateway:
     name: "my-gateway"  # Name of your Gateway resource
     namespace: "gateway-system"  # Namespace of your Gateway
     listenerName: "https"  # Listener name (use "https" or your TLS listener name for HTTPS)
   ```
3. Ensure you have a Gateway resource deployed in your cluster

When `useGatewayAPI: true`, the chart will create HTTPRoute resources instead of Ingress resources for all endpoints.

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| basicAuth.enabled | bool | `false` |  |
| blch.binary | string | `""` |  |
| blch.config.overrides | string | `"[tx_index]\nindexer = \"kv\""` |  |
| blch.homeDir | string | `"cosmos"` |  |
| blch.id | string | `""` |  |
| blch.minGasPrice | string | `""` |  |
| blch.name | string | `""` |  |
| blch.network | string | `""` |  |
| blch.nodeType | string | `""` |  |
| blch.pruning.interval | int | `10` |  |
| blch.pruning.keepEvery | int | `0` |  |
| blch.pruning.keepRecent | int | `100` |  |
| blch.pruning.minRetainBlocks | int | `100` |  |
| blch.pruning.strategy | string | `"custom"` |  |
| blch.skipInvariants | bool | `true` |  |
| blockRollbackInitContainer.enabled | bool | `false` |  |
| cosmos-exporter.enabled | bool | `false` |  |
| cosmos-exporter.nodeSelector | bool | `false` | `{}` |
| debugInitContainer.enabled | bool | `false` |  |
| debugSidecar.enabled | bool | `false` |  |
| endpoints.grpc.additionalIngressAnnotations | object | `{}` |  |
| endpoints.grpc.enabled | bool | `false` |  |
| endpoints.grpc.servicePort | int | `9090` |  |
| endpoints.rest.additionalIngressAnnotations | object | `{}` |  |
| endpoints.rest.enabled | bool | `false` |  |
| endpoints.rest.servicePort | int | `1317` |  |
| endpoints.rpc.additionalIngressAnnotations | object | `{}` |  |
| endpoints.rpc.enabled | bool | `true` |  |
| endpoints.rpc.servicePort | int | `26657` |  |
| endpoints.ws-rpc.additionalIngressAnnotations | object | `{}` |  |
| endpoints.ws-rpc.enabled | bool | `false` |  |
| endpoints.ws-rpc.path | string | `"/websocket"` |  |
| endpoints.ws-rpc.servicePort | int | `26657` |  |
| endpoints.ws.additionalIngressAnnotations | object | `{}` |  |
| endpoints.ws.enabled | bool | `false` |  |
| endpoints.ws.servicePort | int | `8546` |  |
| endpointsBaseDomain | string | `""` |  |
| gateway.listeners | list | `[]` |  |
| gateway.name | string | `""` |  |
| gateway.namespace | string | `""` |  |
| healthcheck.readinessProbe.failureThreshold | int | `3` |  |
| healthcheck.readinessProbe.initialDelaySeconds | int | `1` |  |
| healthcheck.readinessProbe.periodSeconds | int | `10` |  |
| healthcheck.readinessProbe.successThreshold | int | `1` |  |
| healthcheck.readinessProbe.timeoutSeconds | int | `10` |  |
| healthcheck.resources.requests.cpu | string | `"5m"` |  |
| healthcheck.resources.requests.memory | string | `"16Mi"` |  |
| healthcheck.startupProbe.failureThreshold | int | `30` |  |
| healthcheck.startupProbe.initialDelaySeconds | int | `1` |  |
| healthcheck.startupProbe.periodSeconds | int | `10` |  |
| healthcheck.startupProbe.successThreshold | int | `1` |  |
| healthcheck.startupProbe.timeoutSeconds | int | `10` |  |
| image | string | `""` |  |
| imagePullPolicy | string | `"Always"` |  |
| imagePullSecrets | string | `""` |  |
| imageTag | string | `""` |  |
| maxUnavailable | string | `""` |  |
| monitoring.alerts.enabled | bool | `false` |  |
| monitoring.alerts.growingBlockHeightDifference | int | `25` |  |
| monitoring.alerts.maximumBlockHeightDifference | int | `100` |  |
| monitoring.alerts.maximumPeerDropPercentage | int | `25` |  |
| monitoring.enabled | bool | `false` |  |
| monitoring.publicRpcEndpoint | string | `""` |  |
| nodeSelectorKey | string | `""` |  |
| podAntiAffinityPerNode | bool | `true` |  |
| publishSnapshot.cronJobSchedule | string | `"0 */12 * * *"` |  |
| publishSnapshot.enabled | bool | `false` |  |
| publishSnapshot.pathPrefix | string | `""` |  |
| replicas | string | `""` |  |
| rollingUpdateEnabled | bool | `false` |  |
| service.ports.grpc.containerPort | int | `9090` |  |
| service.ports.grpc.port | int | `9090` |  |
| service.ports.grpc.protocol | string | `"TCP"` |  |
| service.ports.prometheus.containerPort | int | `9091` |  |
| service.ports.prometheus.port | int | `9091` |  |
| service.ports.prometheus.protocol | string | `"TCP"` |  |
| service.ports.rest.containerPort | int | `1317` |  |
| service.ports.rest.port | int | `1317` |  |
| service.ports.rest.protocol | string | `"TCP"` |  |
| service.ports.rpc.containerPort | int | `26657` |  |
| service.ports.rpc.port | int | `26657` |  |
| service.ports.rpc.protocol | string | `"TCP"` |  |
| service.ports.ws.containerPort | int | `8546` |  |
| service.ports.ws.port | int | `8546` |  |
| service.ports.ws.protocol | string | `"TCP"` |  |
| service.publishSvcDuringSync | bool | `true` |  |
| service.type | string | `"ClusterIP"` |  |
| service.p2p.containerPort | int | `26656` |  |
| service.p2p.port | int | `26656` |  |
| service.p2p.protocol | string | `"TCP"` |  |
| service.p2p.publishSvcDuringSync | bool | `true` |  |
| service.p2p.type | string | `"LoadBalancer"` |  |
| service.p2p.publishSvcDuringSync | bool | `true` |  |
| sidecar.args | list | `[]` |  |
| sidecar.command[0] | string | `"/bin/sh"` |  |
| sidecar.configMaps | list | `[]` |  |
| sidecar.enabled | bool | `false` |  |
| sidecar.env | list | `[]` |  |
| sidecar.envFrom | list | `[]` |  |
| sidecar.image | string | `"nginx:alpine"` |  |
| sidecar.imagePullPolicy | string | `"IfNotPresent"` |  |
| sidecar.name | string | `"sidecar"` |  |
| sidecar.ports | list | `[]` |  |
| sidecar.resources | object | `{}` |  |
| storage | string | `"300Gi"` |  |
| storageClassName | string | `""` |  |
| tolerations | list | `[]` |  |
| toolkitImage | string | `""` |  |
| toolkitImageTag | string | `""` |  |
| useGatewayAPI | bool | `false` |  |
| volumeRetainPolicy | string | `"Delete"` |  |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.14.2](https://github.com/norwoodj/helm-docs/releases/v1.14.2)

## Contributing

[Contributing guidelines](../../README.md#contributing)

## License

[License](../../LICENCE)
