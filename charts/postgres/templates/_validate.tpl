{{/*
Validate required values at install time.
*/}}
{{- if and (not .Values.auth.existingSecret) (not .Values.auth.password) (not .Values.auth.postgresPassword) }}
{{- /* passwords will be auto-generated — OK */ -}}
{{- end }}
{{- if gt (int .Values.replicaCount) 1 }}
{{- fail "This chart runs a single primary (replicaCount must be 1). Use an HA operator for replicas." }}
{{- end }}
