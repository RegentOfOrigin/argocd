{{/*
Common labels
*/}}
{{- define "qbittorrent.labels" -}}
helm.sh/chart: {{ .Chart.Name }}
{{ include "qbittorrent.selectorLabels" . }}
{{- with .Values.qbittorrent.image.tag }}
app.kubernetes.io/version: {{ . | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "qbittorrent.selectorLabels" -}}
app.kubernetes.io/name: qbittorrent
app.kubernetes.io/instance: qbittorrent
{{- end }}
