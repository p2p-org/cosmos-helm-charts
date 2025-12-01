{{- define "blch-node.labels" -}}
app.kubernetes.io/name: {{ .Release.Name }}
{{- $labels := .Values.labels }}
{{- if not $labels }}
{{- $labels = .Values.commonLabels }}
{{- end }}
{{- with $labels }}
{{- toYaml . | nindent 0 }}
{{- end }}
{{- end }}

{{/*
Common environment variables for init containers and node container
Based on cosmosfullnode.yaml pod template
*/}}
{{- define "blch-node.containerEnv" -}}
{{- $homeDir := .Values.blch.homeDir -}}
{{- $home := printf "/home/operator/%s" $homeDir -}}
- name: HOME
  value: {{ $home | quote }}
- name: CHAIN_HOME
  value: {{ $home | quote }}
- name: homeDir
  value: {{ $homeDir | quote }}
- name: GENESIS_FILE
  value: {{ printf "%s/config/genesis.json" $home | quote }}
- name: ADDRBOOK_FILE
  value: {{ printf "%s/config/addrbook.json" $home | quote }}
- name: CONFIG_DIR
  value: {{ printf "%s/config" $home | quote }}
- name: DATA_DIR
  value: {{ printf "%s/data" $home | quote }}
{{- with .Values.blch.id }}
- name: CHAIN_ID
  value: {{ . | quote }}
{{- end }}
{{- with .Values.blch.network }}
- name: NETWORK
  value: {{ . | quote }}
{{- end }}
{{- with .Values.blch.binary }}
- name: CHAIN_BINARY
  value: {{ . | quote }}
{{- end }}
- name: NODE_NAME
  valueFrom:
    fieldRef:
      fieldPath: metadata.name
{{- end }}

{{/*
Volume mounts for init containers
Based on cosmosfullnode.yaml pod template
*/}}
{{- define "blch-node.initContainerVolumeMounts" -}}
{{- $homeDir := .Values.blch.homeDir -}}
{{- $home := printf "/home/operator/%s" $homeDir -}}
- mountPath: {{ printf "%s/data" $home }}
  name: data
- mountPath: {{ printf "%s/config" $home }}
  name: config
- mountPath: /tmp
  name: vol-system-tmp
- mountPath: {{ printf "%s/.tmp" $home }}
  name: vol-tmp
- mountPath: {{ printf "%s/.config" $home }}
  name: vol-config
{{- end }}

{{/*
Volume mounts for node container
Based on cosmosfullnode.yaml pod template
*/}}
{{- define "blch-node.nodeContainerVolumeMounts" -}}
{{- $homeDir := .Values.blch.homeDir -}}
{{- $home := printf "/home/operator/%s" $homeDir -}}
- mountPath: {{ printf "%s/data" $home }}
  name: data
- mountPath: {{ printf "%s/config" $home }}
  name: config
- mountPath: /tmp
  name: vol-system-tmp
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
