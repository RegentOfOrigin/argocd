{{/*
Common labels
*/}}
{{- define "sabnzbd.labels" -}}
helm.sh/chart: {{ .Chart.Name }}
{{ include "sabnzbd.selectorLabels" . }}
{{- with .Values.sabnzbd.image.tag }}
app.kubernetes.io/version: {{ . | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "sabnzbd.selectorLabels" -}}
app.kubernetes.io/name: sabnzbd
app.kubernetes.io/instance: sabnzbd
{{- end }}
