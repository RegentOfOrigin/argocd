{{/*
Expand the name of the chart.
*/}}
{{- define "application.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "application.fullname" -}}
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

{{/*
Common labels
*/}}
{{- define "application.labels" -}}
helm.sh/chart: {{ .Chart.Name }}
{{ include "application.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "application.selectorLabels" -}}
app.kubernetes.io/name: {{ .Chart.Name }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "application.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "application.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{- define "application.volumes" -}}
- name: config
  persistentVolumeClaim:
    claimName: {{ include "application.fullname" . }}-config-pvc
{{- if .Values.multimedia.enable }}
- name: multimedia
  {{ .Values.multimedia.volume | default .Values.global.multimedia | toYaml | nindent 2 }}
{{- end }}
{{- if .Values.backups.enable }}
- name: backups
  {{ .Values.backups.volume | default .Values.global.backups | toYaml | nindent 2 }}
{{- end }}
{{ toYaml .Values.volumes }}
{{- end }}

{{- define "application.volumeMounts" -}}
- name: config
  mountPath: /config
{{- if .Values.mountMultimediaVolume }}
- name: multimedia
  mountPath: /multimedia
{{- end }}
{{- if .Values.mountBackupsVolume }}
- name: backups
  mountPath: /backups
{{- end }}
{{ toYaml .Values.volumeMounts }}
{{- end }}