{{/*
Expand the name of the chart.
*/}}
{{- define "application.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

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

{{/*
Selector labels
*/}}
{{- define "application.selectorLabels" -}}
app.kubernetes.io/name: {{ include "application.name" . }}
app.kubernetes.io/instance: {{ include "application.name" . }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "application.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "application.name" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{- define "ingress.annotations" -}}
{{- with .Values.ingress.hostname }}
{{- if or (hasSuffix ".internal" .) (hasSuffix ".example.com" .) }}
cert-manager.io/cluster-issuer: selfsigned
{{- else }}
cert-manager.io/cluster-issuer: cloudflare
{{- end }}
{{- end }}
{{- with default .Values.global.ingress.whitelistSourceRange .Values.ingress.whitelistSourceRange }}
nginx.ingress.kubernetes.io/whitelist-source-range: {{ . }}
{{- end }}
{{- end }}
