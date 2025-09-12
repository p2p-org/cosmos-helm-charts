# RPC node Helm Chart

A Helm chart for deploying cosmos-sdk based RPC node.
The chart utilizes [the Kubernetes cosmos-operator](https://github.com/strangelove-ventures/cosmos-operator).

## Overview

This chart deploys a complete RPC node including:

- CosmosFullNode (cosmos-operator's CRD)
- Ingress with configrable endpoints (RPC, gRPC, API, WS, etc)
- Optional HTTPRoute support for Gateway API (when `useGatewayAPI: true`)
- Optional sentry mode (remote signer is required and not included in this chart)
- Optional prometheus monitoring for:
  - Default CometBFT metrics
  - Latest block height compared to a given public RPC endpoint
  - Endpoint monitoring for the deployed RPC endpoint
- Optional rcosmos-exporter deployment 
- Optional Use DNS name for P2P external-address
## Prerequisites

- Helm 3.2.0+
- Cosmos-operator
- Ingress Controller (nginx) - **OR** Gateway API with Gateway resource (when using `useGatewayAPI: true`)
- Cert-manager (optional, for TLS)
- Prometheus blackbox exporter (optional, for monitoring)
- Prometheus json exporter (optional, for monitoring)
- external-dns (optional, for external-address dns name)

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

[Contributing guidelines](CONTRIBUTING.md)

## License

Apache 2.0
