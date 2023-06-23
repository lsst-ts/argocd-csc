{{/*
Expand the name of the chart.
*/}}
{{- define "rubintv-broadcaster.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "rubintv-broadcaster.fullname" -}}
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
Create chart name and version as used by the chart label.
*/}}
{{- define "rubintv-broadcaster.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "rubintv-broadcaster.labels" -}}
helm.sh/chart: {{ include "rubintv-broadcaster.chart" . }}
{{ include "rubintv-broadcaster.selectorLabels" . }}
{{- end }}

{{/*
Script name
*/}}
{{- define "rubintv-broadcaster.scriptName" -}}
{{- regexSplit "/" .Values.script -1 | last | trimSuffix ".py" | kebabcase }}
{{- end }}

{{/*
Deployment name
*/}}
{{- define "rubintv-broadcaster.deploymentName" -}}
{{- $name := regexSplit "/" .Values.script -1 | last | trimSuffix ".py" | kebabcase }}
{{- printf "s-%s" $name }}
{{- end }}


{{/*
Selector labels
*/}}
{{- define "rubintv-broadcaster.selectorLabels" -}}
app.kubernetes.io/name: {{ include "rubintv-broadcaster.deploymentName" . }}
app.kubernetes.io/instance: {{ include "rubintv-broadcaster.name" . }}
{{- $values := regexSplit "/" .Values.script -1 }}
{{- if eq 1 (len $values) }}
all: misc
{{- else }}
{{- $all_label := lower (index $values 1) }}
{{- $script := index $values 2 }}
{{- if contains "Isr" $script }}
isr: {{ $all_label }}
{{- end }}
all: {{ $all_label }}
{{- if has $all_label (list "auxtel" "comcam" "bot" "ts8") }}
camera: {{ $all_label }}
{{- else }}
{{- if contains "StarTracker" $script }}
camera: startracker
{{- end }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create a default fully qualified app name for redis.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "rubintv-broadcaster.redis.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- printf "%s-redis" .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s-redis" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Common labels - redis
*/}}
{{- define "rubintv-broadcaster.redis.labels" -}}
helm.sh/chart: {{ include "rubintv-broadcaster.chart" . }}
{{ include "rubintv-broadcaster.redis.selectorLabels" . }}
{{- end }}

{{/*
Selector labels - redis
*/}}
{{- define "rubintv-broadcaster.redis.selectorLabels" -}}
app.kubernetes.io/name: {{ include "rubintv-broadcaster.name" . }}
app.kubernetes.io/instance: {{ include "rubintv-broadcaster.redis.fullname" . }}
{{- end }}
