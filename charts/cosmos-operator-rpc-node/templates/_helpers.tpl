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
