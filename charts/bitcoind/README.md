# Bitcoind Signet Helm Chart

This chart bootstraps a [bitcoin](https://github.com/bitcoin/bitcoin) signet node on a [Kubernetes](https://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager. Bitcoin Core connects to the Bitcoin peer-to-peer network to download and fully validate blocks and transactions.

Further information about Bitcoin Core is available [here](https://github.com/bitcoin/bitcoin).


## TL;DR

```bash
helm template bitcoind . -f values.yaml 
helm install bitcoind . --namespace bitcoind
helm upgrade bitcoind . --namespace bitcoind -f values.yaml
helm uninstall bitcoind --namespace bitcoind
```

This will setup a full node sync it with the signet network.

## Introduction

This chart bootstraps a [bitcoin](https://github.com/bitcoin/bitcoin) deployment on a [Kubernetes](https://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.31+
- Helm 3.16.0+

## Installing the Chart

To install the chart with the release name `bitcoind`

````bash
helm template bitcoind . -f values.yaml 
helm install bitcoind . --namespace bitcoind
helm upgrade bitcoind . --namespace bitcoind -f values.yaml
helm uninstall bitcoind --namespace bitcoind
````

These commands deploy a bitcoin full node on the Kubernetes cluster using the default configuration.

> **Tip** List all releases using `helm list`


```bash
	helm list -n bitcoind
```

## Uninstalling the Chart

To uninstall/delete the `bitcoind` deployment

```bash
$ helm delete bitcoind -n bitcoind
```
The command removes all the Kubernetes components associated with the chart and deletes the release.

## Troubleshot the node

````bash
kubectl exec -it <pod_name> -n <namespace> -- /bin/bash
apt add curl net-tools procps
````

````bash 
#Check node info
bitcoin-cli -rpcport=38332 -rpcuser=ojfknyQQ -rpcpassword=xxxxxxxxx getnetworkinfo
bitcoin-cli -rpcport=38332 -rpcuser=ojfknyQQ -rpcpassword=xxxxxxxxx getblockchaininfo
curl --user foo:xxxxxx --data-binary '{"jsonrpc": "1.0", "id": "curltest", "method": "getbestblockhash", "params": []}' -H 'content-type: text/plain;' http://localhost:38332/
````

- Quick test with Docker:
```bash
docker run --rm -it \
  bitcoin/bitcoin \
  -p 38332:38332 \
  -p 38333:38333 \
  -printtoconsole \
  -signet=1 \
  -rpcallowip=0.0.0.0/0 \
  -rpcbind=0.0.0.0 \
  -rpcuser=foo \
  -rpcpassword=bar \
  -rpcport=38332
```

## Parameters

### Image Parameters

| Name                      | Description                                     | Value |
| ------------------------- | ----------------------------------------------- | ----- |
| `image.repository` | the image repository to be used | `bitcoin/bitcoind`  |
| `image.tag` | the image version | `28.0`  |
| `image.digest` | the image digest, use this if there is no private registry | `""`  |
| `image.pullPolicy` | pull policy | `IfNotPresent`  |

### Bitcoin Core Specific Configuration

| Name                      | Description                                     | Value |
| ------------------------- | ----------------------------------------------- | ----- |
| `configuration.rpcuser` | optional, if not quoted it will be generated | `""`  |
| `configuration.server` | the image repository to be used | `1`  |
| `configuration.network` | can be any of mainnet, regtest, signet or testnet, if omitted mainnet will be used only a single network per deployment is supported | `mainnet`  |
| `configuration.prune` | Autopprune (-prune=550) allows you to reduce your historical blockchain data to a given target (in MB, example uses 550 which is the minimum). You can't throw away all blocks because you may need to "roll back a couple of block" if there is a chain reorganisation. If you set prune=1 (== manual mode), you can then manually prune your blockchain (use RPC call pruneblockchain <height>) | `""`  |
| `configuration.passwordLength` | The length of the password for the RPC user | `50`  |

### Persistent Volume Settings

| Name                      | Description                                     | Value |
| ------------------------- | ----------------------------------------------- | ----- |
| `persistence.accessMode` | Access mode of the mounted drive. | `ReadWriteOnce`  |
| `persistence.size` | Size of the mounted drive. | `14Gb`  |
| `persistence.storageClass` | The storage class used to provision the drive. | `local-path`  |


### Persistent Volume Settings

| Name                      | Description                                     | Value |
| ------------------------- | ----------------------------------------------- | ----- |
| `resources.requests.cpu` | Limits and requests for CPU resources are measured in cpu units. | `250m`  |
| `resources.requests.memory` | You can express memory as a plain integer or as a fixed-point number using one of these quantity suffixes: E, P, T, G, M, k. You can also use the power-of-two equivalents: Ei, Pi, Ti, Gi, Mi, Ki. | `1G`  |
| `resources.limits.cpu` | Limits and requests for CPU resources are measured in cpu units. | `250m`  |
| `resources.limits.memory` | You can express memory as a plain integer or as a fixed-point number using one of these quantity suffixes: E, P, T, G, M, k. You can also use the power-of-two equivalents: Ei, Pi, Ti, Gi, Mi, Ki. | `1G`  |
