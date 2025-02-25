{{/*
Common labels
*/}}
{{- define "application.labels" -}}
helm.sh/chart: {{ .Chart.Name }}
{{ include "application.selectorLabels" . }}
{{- with .Values.image.tag }}
app.kubernetes.io/version: {{ . | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{- define "application.securityContext" -}}
{{- if not (or (hasPrefix "linuxserver" .Values.image.repository) (hasPrefix "hotio" .Values.image.repository)) }}
{{- with .Values.user }}
runAsUser: {{ . }}
{{- end }}
{{- with .Values.group }}
runAsGroup: {{ . }}
{{- end }}
{{- end }}
{{- with .Values.securityContext }}
{{- toYaml . }}
{{- end }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "application.selectorLabels" -}}
app.kubernetes.io/name: {{ .Release.Name }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{- define "ingress.annotations" -}}
{{- with .Values.ingress.hostname }}
cert-manager.io/cluster-issuer: {{ if (hasSuffix ".internal" .) }}selfsigned{{ else }}cloudflare{{ end }}
{{- end }}
{{- with .Values.ingress.whitelistSourceRange }}
nginx.ingress.kubernetes.io/whitelist-source-range: {{ . }}
{{- end }}
{{- end }}

{{- define "application.image.registry" -}}
{{- with .Values.image.registry }}
{{ . }}/
{{- end }}
{{- end }}

{{- define "application.image.tag" -}}
{{- with .Values.image.tag }}
:{{ . }}
{{- end }}
{{- end }}
