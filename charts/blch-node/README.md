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

## Contributing

[Contributing guidelines](../../README.md#contributing)

## License

[License](../../LICENCE)
