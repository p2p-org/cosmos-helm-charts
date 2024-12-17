# Namada Indexer Helm Chart

A Helm chart for deploying the Namada blockchain indexer and its components.

## Overview

This chart deploys a complete Namada indexing solution including:

- Chain indexer
- Governance indexer
- PoS indexer
- Rewards indexer
- Parameters indexer
- Transaction indexer
- Web API server
- PostgreSQL database (optional)
- Redis cache (optional)

## Prerequisites

- Helm 3.2.0+
- Ingress Controller (nginx)
- Cert-manager (optional, for TLS)

## Installation

1. Add required Helm repositories:

```bash
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo add zalando https://opensource.zalando.com/postgres-operator/charts/postgres-operator
helm repo update
```

2. Update chart dependencies:

```bash
helm dependency update .
helm dependency build .
```

3. Install the chart:

```bash
helm install namada-indexer . \
  --create-namespace \
  --namespace namada-indexer \
  -f values.yaml
```

For a basic installation with default values:

```bash
helm install namada-indexer . \
  --create-namespace \
  --namespace namada-indexer
```

To upgrade an existing installation:

```bash
helm upgrade namada-indexer . \
  --namespace namada-indexer \
  -f values.yaml
```

## Configuration

### Database Configuration

#### Option 1: Built-in PostgreSQL

```yaml
postgresOperator:
  install:
    enabled: true
  enabled: true
  teamId: "namada"
  volume:
    size: 100Gi
    storageClass: "oci-bv"
  numberOfInstances: 3
```

#### Option 2: External PostgreSQL

```yaml
postgresOperator:
  install:
    enabled: false
  enabled: false

externalPostgres:
  enabled: true
  host: "your-postgres-host"
  port: "5432"
  credentialSecret:
    name: "your-postgres-secret"
```

### Redis Configuration

#### Option 1: Built-in Redis (Default)

```yaml
redis:
  install:
    enabled: true
  enabled: true
  architecture: replication
  sentinel:
    enabled: true
    quorum: 2
  replica:
    replicaCount: 3
```

#### Option 2: External Redis

```yaml
redis:
  install:
    enabled: false
  enabled: false

externalRedis:
  enabled: true
  host: "your-redis-host"
  port: "6379"
```

### Indexer Configuration

```yaml
configmaps:
  config:
    data:
      TENDERMINT_URL: "http://your-tendermint-rpc:26657/"

containers:
  chain:
    resources:
      limits:
        cpu: "1"
        memory: "1Gi"
  webserver:
    ingress:
      enabled: true
      hosts:
        - host: api.your-domain.com
```

## Dependencies

This chart depends on:

- PostgreSQL Operator (optional)
- Redis (optional)

## Contributing

[Contributing guidelines](CONTRIBUTING.md)

## License

Apache 2.0
