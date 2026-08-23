{{/*
Common labels
*/}}
{{- define "home-assistant.labels" -}}
helm.sh/chart: {{ .Chart.Name }}
{{ include "home-assistant.selectorLabels" . }}
{{- with .Values.image.tag }}
app.kubernetes.io/version: {{ . | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}
