{{/*
Common labels
*/}}
{{- define "blch-node.commonLabels" -}}
{{- if and .Values.commonLabels (kindIs "map" .Values.commonLabels) }}
{{- toYaml .Values.commonLabels | nindent 0 }}
{{- end }}
{{- end }}

{{/*
Common environment variables for containers
*/}}
{{- define "blch-node.containerEnv" -}}
- name: HOME_DIR
  value: {{ .Values.blch.homeDir }}
- name: DATA_DIR
  value: {{ .Values.blch.dataDir }}
- name: CHAIN_ID
  value: {{ .Values.blch.id | quote }}
- name: NETWORK
  value: {{ .Values.blch.network | quote }}
- name: BINARY
  value: {{ .Values.blch.binary | quote }}
- name: SKIP_INVARIANTS
  value: {{ .Values.blch.skipInvariants | quote }}
- name: MIN_GAS_PRICE
  value: {{ .Values.blch.minGasPrice | quote }}
{{- end }}

{{/*
Common volume mounts
*/}}
{{- define "blch-node.containerVolumeMounts" -}}
- mountPath: {{ .Values.home }}/{{ .Values.chainHome }}
  name: vol-chain-home
- mountPath: /tmp
  name: vol-system-tmp
- mountPath: {{ .Values.home }}/.tmp
  name: vol-tmp
- mountPath: {{ .Values.home }}/.config
  name: vol-config
{{- end }}

{{/*
Endpoints configuration
*/}}
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
