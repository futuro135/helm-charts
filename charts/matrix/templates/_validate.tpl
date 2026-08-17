{{- if not .Values.server.name }}
{{- fail "server.name is required (Matrix server_name, e.g. matrix.example.com)" }}
{{- end }}
{{- if not .Values.database.host }}
{{- fail "database.host is required (external PostgreSQL hostname)" }}
{{- end }}
{{- if and (not .Values.synapse.existingSecret) (not .Values.database.password) (not .Values.database.existingSecret) }}
{{- /* password will be auto-generated — OK for demos, not for existing DBs */ -}}
{{- end }}
{{- if gt (int .Values.synapse.replicaCount) 1 }}
{{- fail "This chart runs a single Synapse process (synapse.replicaCount must be 1). Use Synapse workers for HA." }}
{{- end }}
