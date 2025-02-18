{{/*
Common labels
*/}}
{{- define "sabnzbd.labels" -}}
helm.sh/chart: {{ .Chart.Name }}
{{ include "sabnzbd.selectorLabels" . }}
{{- if .Values.qbittorrent.image.tag }}
app.kubernetes.io/version: {{ .Values.qbittorrent.image.tag | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "sabnzbd.selectorLabels" -}}
app.kubernetes.io/name: {{- printf "%s-%s" .Release.Name .Chart.Name | trunc 63 | trimSuffix "-" }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}
