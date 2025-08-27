{{- define "host" -}}
{{- $context := .context -}}
{{- $endpointName := .endpointName -}}
{{- if (index $context.Values.endpoints $endpointName).host }}
{{- printf "%s" (index $context.Values.endpoints $endpointName).host }}
{{- else if eq $endpointName "rpc" }}
{{- printf "%s-%s.%s" $context.Release.Name $context.Values.blch.nodeType $context.Values.endpointsBaseDomain }}
{{- else }}
{{- printf "%s-%s-%s.%s" $context.Release.Name $context.Values.blch.nodeType $endpointName $context.Values.endpointsBaseDomain }}
{{- end -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "cosmos-operator-rpc-node.commonLabels" -}}
{{- if and .Values.commonLabels (kindIs "map" .Values.commonLabels) }}
{{- toYaml .Values.commonLabels | nindent 0 }}
{{- end }}
{{- end }}

{{/*
Network configuration with defaults and user overrides
*/}}
{{- define "cosmos-operator-rpc-node.networkConfig" -}}
{{- /* Initialize default network configuration */ -}}
{{- $defaultNetwork := dict -}}

{{- /* CometBFT configuration */ -}}
{{- $cometbft := dict -}}
{{- $_ := set $cometbft "validators" (dict "enabled" true "interval" 30) -}}
{{- $_ := set $cometbft "block" (dict "enabled" true "interval" 30 "window" 500 "tx" (dict "enabled" true) "uptime" (dict "persistence" false)) -}}
{{- $_ := set $defaultNetwork "cometbft" $cometbft -}}

{{- /* Tendermint configuration */ -}}
{{- $tendermint := dict -}}
{{- $_ := set $tendermint "bank" (dict "addresses" list "enabled" false "interval" 30) -}}
{{- $_ := set $tendermint "distribution" (dict "enabled" true "interval" 30) -}}
{{- $_ := set $tendermint "gov" (dict "enabled" true "interval" 30) -}}
{{- $_ := set $tendermint "staking" (dict "enabled" true "interval" 30) -}}
{{- $_ := set $tendermint "slashing" (dict "enabled" true "interval" 30) -}}
{{- $_ := set $tendermint "upgrade" (dict "enabled" true "interval" 30) -}}
{{- $_ := set $defaultNetwork "tendermint" $tendermint -}}

{{- /* Mezo configuration */ -}}
{{- $mezo := dict -}}
{{- $_ := set $mezo "poa" (dict "enabled" false "interval" 30) -}}
{{- $_ := set $defaultNetwork "mezo" $mezo -}}

{{- /* Babylon configuration */ -}}
{{- $babylon := dict -}}
{{- $_ := set $babylon "bls" (dict "enabled" false "interval" 30) -}}
{{- $_ := set $defaultNetwork "babylon" $babylon -}}

{{- /* Lombard configuration */ -}}
{{- $lombard := dict -}}
{{- $_ := set $lombard "ledger" (dict "addresses" list "enabled" false "interval" 30) -}}
{{- $_ := set $defaultNetwork "lombard" $lombard -}}

{{- /* Namada configuration */ -}}
{{- $namada := dict -}}
{{- $_ := set $namada "account" (dict "addresses" list "enabled" false "interval" 30) -}}
{{- $_ := set $namada "pos" (dict "enabled" false "interval" 30) -}}
{{- $_ := set $defaultNetwork "namada" $namada -}}

{{- /* CoreDAO configuration */ -}}
{{- $coredao := dict -}}
{{- $_ := set $coredao "block" (dict "enabled" false "interval" 30 "window" 500) -}}
{{- $_ := set $coredao "validator" (dict "enabled" false "interval" 30) -}}
{{- $_ := set $defaultNetwork "coredao" $coredao -}}

{{- /* Merge user configuration with defaults */ -}}
{{- $userNetwork := default dict .Values.cosmosExporter.networkConfig -}}
{{- $mergedNetwork := merge $defaultNetwork $userNetwork -}}
{{- toYaml $mergedNetwork -}}
{{- end }}
