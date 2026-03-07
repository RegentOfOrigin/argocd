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

{{/*
Selector labels
*/}}
{{- define "home-assistant.selectorLabels" -}}
app.kubernetes.io/name: {{ .Release.Name }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{- define "home-assistant.image" -}}
{{- with .Values.image }}
{{ with .registry }}{{ . }}/{{ end }}{{ .repository }}{{ with .tag }}:{{ . }}{{ end }}{{ with .digest }}@{{ . }}{{ end }}
{{- end }}
{{- end }}
