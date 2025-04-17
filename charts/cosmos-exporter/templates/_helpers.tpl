{{/*
Expand the name of the chart.
*/}}
{{- define "cosmos-exporter.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "cosmos-exporter.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "cosmos-exporter.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "cosmos-exporter.labels" -}}
helm.sh/chart: {{ $.Chart.Name }}-{{ $.Chart.Version | replace "+" "_" }}
app.kubernetes.io/name: {{ $.Chart.Name }}
app.kubernetes.io/instance: {{ $.Release.Name }}
app.kubernetes.io/version: {{ $.Chart.AppVersion }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{/*
Selector labels
*/}}
{{- define "cosmos-exporter.selectorLabels" -}}
app.kubernetes.io/name: {{ $.Chart.Name }}
app.kubernetes.io/instance: {{ $.Release.Name }}
{{- end -}}

{{- define "mergedEnv" -}}
  {{- $envOverrides := .Values.envOverride | default (list) }}
  {{- $env := .Values.env | default (list) }}
  {{- $result := list }}

  {{- range $envItem := $env }}
    {{- $override := false }}
    {{- range $envOverride := $envOverrides }}
      {{- if eq $envOverride.name $envItem.name }}
        {{- $override = $envOverride }}
      {{- end }}
    {{- end }}

    {{- if $override }}
      {{- $result = append $result (dict "name" $envItem.name "value" $override.value) }}
    {{- else }}
      {{- $result = append $result (dict "name" $envItem.name "value" $envItem.value) }}
    {{- end }}
  {{- end }}

  {{/* Add any new environment variables from envOverride that don't exist in env */}}
  {{- range $envOverride := $envOverrides }}
    {{- $exists := false }}
    {{- range $envItem := $env }}
      {{- if eq $envItem.name $envOverride.name }}
        {{- $exists = true }}
      {{- end }}
    {{- end }}
    {{- if not $exists }}
      {{- $result = append $result (dict "name" $envOverride.name "value" $envOverride.value) }}
    {{- end }}
  {{- end }}

  {{- range $item := $result }}
    - name: {{ $item.name }}
    {{- if $item.value }}
      value: "{{ $item.value }}"
    {{- else }}
      value: ""
    {{- end }}
  {{- end }}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "cosmos-exporter.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "cosmos-exporter.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}
