{{- define "host" -}}
{{- $context := .context -}}
{{- $endpointName := .endpointName -}}
{{- if (index $context.Values.endpoints $endpointName).host }}
{{- printf "%s" (index $context.Values.endpoints $endpointName).host }}
{{- else if eq $endpointName "rpc" }}
{{- printf "%s-%s.%s" $context.Release.Name $context.Values.blch.nodeType "tm.p2p.org" }}
{{- else }}
{{- printf "%s-%s-%s.%s" $context.Release.Name $context.Values.blch.nodeType $endpointName "tm.p2p.org" }}
{{- end -}}
{{- end -}}
