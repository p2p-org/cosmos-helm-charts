{{- define "namada-indexer.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "namada-indexer.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{- define "namada-indexer.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "namada-indexer.labels" -}}
helm.sh/chart: {{ include "namada-indexer.chart" . }}
{{ include "namada-indexer.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "namada-indexer.selectorLabels" -}}
app.kubernetes.io/name: {{ include "namada-indexer.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "namada-indexer.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "namada-indexer.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Container configuration helper
*/}}
{{- define "namada-indexer.containerConfig" -}}
{{- $ := index . 0 -}}
{{- $container := index . 1 -}}
{{- with $container -}}
{{- if .command }}
command:
{{- toYaml .command | nindent 2 }}
{{- end }}
{{- if .args }}
args:
{{- toYaml .args | nindent 2 }}
{{- end }}
{{- if .ports }}
ports:
{{- toYaml .ports | nindent 2 }}
{{- end }}
{{- if .livenessProbe }}
livenessProbe:
{{- toYaml .livenessProbe | nindent 2 }}
{{- end }}
{{- end }}
{{- if $.Values.containerDefaults }}
resources:
{{- toYaml $.Values.containerDefaults.resources | nindent 2 }}
envFrom:
{{- toYaml $.Values.containerDefaults.envFrom | nindent 2 }}
env:
{{- end }}
{{- end }}

{{/*
Database configuration helper
*/}}
{{- define "namada-indexer.dbConfig" -}}
{{- if .Values.postgresOperator.enabled }}
DB_HOST: "{{ include "namada-indexer.fullname" . }}-db.{{ .Release.Namespace }}.svc.cluster.local"
SECRET_NAME: "namada.{{ .Release.Namespace }}-db.credentials.postgresql.acid.zalan.do"
{{- else if .Values.externalPostgres.enabled }}
DB_HOST: {{ .Values.externalPostgres.host | quote }}
SECRET_NAME: {{ .Values.externalPostgres.credentialSecret.name | quote }}
{{- end }}
{{- end }}

{{/*
Database environment variables
*/}}
{{- define "namada-indexer.dbEnv" -}}
{{- if .Values.postgresOperator.enabled }}
- name: DB_USER
  valueFrom:
    secretKeyRef:
      name: namada.{{ .Release.Name }}-db.credentials.postgresql.acid.zalan.do
      key: username
- name: DB_PASSWORD
  valueFrom:
    secretKeyRef:
      name: namada.{{ .Release.Name }}-db.credentials.postgresql.acid.zalan.do
      key: password
{{- else if .Values.externalPostgres.enabled }}
- name: DB_USER
  valueFrom:
    secretKeyRef:
      name: {{ .Values.externalPostgres.credentialSecret.name }}
      key: {{ .Values.externalPostgres.credentialSecret.usernameKey | default "username" }}
- name: DB_PASSWORD
  valueFrom:
    secretKeyRef:
      name: {{ .Values.externalPostgres.credentialSecret.name }}
      key: {{ .Values.externalPostgres.credentialSecret.passwordKey | default "password" }}
{{- end }}
{{- end }}

{{/*
Database configuration validation
*/}}
{{- define "namada-indexer.validateDbConfig" -}}
{{- if and .Values.postgresOperator.enabled .Values.externalPostgres.enabled }}
{{- fail "Cannot enable both postgresOperator and externalPostgres at the same time" }}
{{- end }}
{{- if not (or .Values.postgresOperator.enabled .Values.externalPostgres.enabled) }}
{{- fail "Either postgresOperator or externalPostgres must be enabled" }}
{{- end }}
{{- end }}

{{/*
Redis configuration helper
*/}}
{{- define "namada-indexer.redisConfig" -}}
{{- if .Values.redis.install.enabled }}
REDIS_HOST: "{{ .Release.Name }}-redis-master.{{ .Release.Namespace }}.svc.cluster.local"
REDIS_PORT: "6379"
REDIS_SECRET_NAME: "{{ .Release.Name }}-redis"
{{- else if .Values.externalRedis.enabled }}
REDIS_HOST: {{ .Values.externalRedis.host | quote }}
REDIS_PORT: {{ .Values.externalRedis.port | quote }}
REDIS_SECRET_NAME: {{ .Values.externalRedis.credentialSecret.name | quote }}
{{- end }}
{{- end }}

{{/*
Redis configuration validation
*/}}
{{- define "namada-indexer.validateRedisConfig" -}}
{{- if and .Values.redis.install.enabled .Values.externalRedis.enabled }}
{{- fail "Cannot enable both redis.install and externalRedis at the same time" }}
{{- end }}
{{- if not (or .Values.redis.install.enabled .Values.externalRedis.enabled) }}
{{- fail "Either redis.install or externalRedis must be enabled" }}
{{- end }}
{{- end }}
