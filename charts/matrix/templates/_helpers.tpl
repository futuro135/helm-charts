{{/*
Expand the name of the chart.
*/}}
{{- define "matrix.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
*/}}
{{- define "matrix.fullname" -}}
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

{{- define "matrix.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "matrix.labels" -}}
helm.sh/chart: {{ include "matrix.chart" . }}
{{ include "matrix.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{- define "matrix.selectorLabels" -}}
app.kubernetes.io/name: {{ include "matrix.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{- define "matrix.synapse.fullname" -}}
{{- if .Values.synapse.nameOverride }}
{{- .Values.synapse.nameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-synapse" (include "matrix.fullname" .) | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}

{{- define "matrix.element.fullname" -}}
{{- if .Values.element.nameOverride }}
{{- .Values.element.nameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-element" (include "matrix.fullname" .) | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}

{{- define "matrix.synapse.labels" -}}
{{ include "matrix.labels" . }}
app.kubernetes.io/component: synapse
{{- end }}

{{- define "matrix.synapse.selectorLabels" -}}
{{ include "matrix.selectorLabels" . }}
app.kubernetes.io/component: synapse
{{- end }}

{{- define "matrix.element.labels" -}}
{{ include "matrix.labels" . }}
app.kubernetes.io/component: element
{{- end }}

{{- define "matrix.element.selectorLabels" -}}
{{ include "matrix.selectorLabels" . }}
app.kubernetes.io/component: element
{{- end }}

{{- define "matrix.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "matrix.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{- define "matrix.secretName" -}}
{{- if .Values.synapse.existingSecret }}
{{- .Values.synapse.existingSecret }}
{{- else }}
{{- printf "%s-secrets" (include "matrix.fullname" .) }}
{{- end }}
{{- end }}

{{- define "matrix.postgresSecretName" -}}
{{- if .Values.database.existingSecret }}
{{- .Values.database.existingSecret }}
{{- else }}
{{- include "matrix.secretName" . }}
{{- end }}
{{- end }}

{{- define "matrix.postgresSecretKey" -}}
{{- if .Values.database.existingSecret -}}
{{- .Values.database.existingSecretKey -}}
{{- else -}}
POSTGRES_PASSWORD
{{- end -}}
{{- end }}

{{- define "matrix.lookupSecret" -}}
{{- $name := index . 0 -}}
{{- $key := index . 1 -}}
{{- $root := index . 2 -}}
{{- $secret := lookup "v1" "Secret" $root.Release.Namespace $name -}}
{{- if and $secret $secret.data (index $secret.data $key) -}}
{{- index $secret.data $key | b64dec -}}
{{- end -}}
{{- end }}

{{- define "matrix.postgresPassword" -}}
{{- if .Values.database.password }}
{{- .Values.database.password }}
{{- else if .Values.synapse.existingSecret }}
{{- "" }}
{{- else }}
{{- $name := include "matrix.secretName" . }}
{{- $existing := include "matrix.lookupSecret" (list $name "POSTGRES_PASSWORD" .) }}
{{- if $existing }}
{{- $existing }}
{{- else }}
{{- randAlphaNum 24 }}
{{- end }}
{{- end }}
{{- end }}

{{- define "matrix.registrationSharedSecret" -}}
{{- if .Values.synapse.registrationSharedSecret }}
{{- .Values.synapse.registrationSharedSecret }}
{{- else if .Values.synapse.existingSecret }}
{{- "" }}
{{- else }}
{{- $name := include "matrix.secretName" . }}
{{- $existing := include "matrix.lookupSecret" (list $name "REGISTRATION_SHARED_SECRET" .) }}
{{- if $existing }}
{{- $existing }}
{{- else }}
{{- randAlphaNum 32 }}
{{- end }}
{{- end }}
{{- end }}

{{- define "matrix.macaroonSecretKey" -}}
{{- if .Values.synapse.macaroonSecretKey }}
{{- .Values.synapse.macaroonSecretKey }}
{{- else if .Values.synapse.existingSecret }}
{{- "" }}
{{- else }}
{{- $name := include "matrix.secretName" . }}
{{- $existing := include "matrix.lookupSecret" (list $name "MACAROON_SECRET_KEY" .) }}
{{- if $existing }}
{{- $existing }}
{{- else }}
{{- randAlphaNum 32 }}
{{- end }}
{{- end }}
{{- end }}

{{- define "matrix.formSecret" -}}
{{- if .Values.synapse.formSecret }}
{{- .Values.synapse.formSecret }}
{{- else if .Values.synapse.existingSecret }}
{{- "" }}
{{- else }}
{{- $name := include "matrix.secretName" . }}
{{- $existing := include "matrix.lookupSecret" (list $name "FORM_SECRET" .) }}
{{- if $existing }}
{{- $existing }}
{{- else }}
{{- randAlphaNum 32 }}
{{- end }}
{{- end }}
{{- end }}

{{- define "matrix.publicBaseUrl" -}}
{{- if .Values.server.publicBaseUrl }}
{{- .Values.server.publicBaseUrl }}
{{- else }}
{{- printf "https://%s" .Values.server.name }}
{{- end }}
{{- end }}
