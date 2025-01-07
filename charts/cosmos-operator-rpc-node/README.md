# RPC node Helm Chart

A Helm chart for deploying cosmos-sdk based RPC node.
The chart utilizes [the Kubernetes cosmos-operator](https://github.com/strangelove-ventures/cosmos-operator).

## Overview

This chart deploys a complete RPC node including:

- CosmosFullNode (cosmos-operator's CRD)
- Ingress with configrable endpoints (RPC, gRPC, API, WS, etc)
- Optional prometheus monitoring for:
  - Default CometBFT metrics
  - Latest block height compared to a given public RPC endpoint
  - Endpoint monitoring for the deployed RPC endpoint

## Prerequisites

- Helm 3.2.0+
- Cosmos-operator
- Ingress Controller (nginx)
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

## Contributing

[Contributing guidelines](CONTRIBUTING.md)

## License

Apache 2.0
