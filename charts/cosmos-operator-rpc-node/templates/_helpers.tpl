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
