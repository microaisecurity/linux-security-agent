{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "co.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "co.fullname" -}}
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
{{- define "co.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "co.labels" -}}
helm.sh/chart: {{ include "co.chart" . }}
{{ include "co.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "co.selectorLabels" -}}
app.kubernetes.io/name: {{ include "co.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "co.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "co.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}



helm repo add newrelic https://helm-charts.newrelic.com
helm repo update
kubectl create namespace newrelic ; helm upgrade --install newrelic-bundle newrelic/nri-bundle --set global.licenseKey=c644851097c40ffb2acb9aa4c08066748e0cNRAL --set global.cluster=kube  --namespace=newrelic --set newrelic-infrastructure.privileged=true --set global.lowDataMode=true --set ksm.enabled=true --set kubeEvents.enabled=true --set newrelic-pixie.enabled=true --set newrelic-pixie.apiKey=px-api-9f5b9b19-8e28-498d-bae4-14e5ff5d5fbb --set pixie-chart.enabled=true --set pixie-chart.deployKey=px-dep-1aae4475-08c3-4155-8b49-2e4b0813eb4d --set pixie-chart.clusterName=kube