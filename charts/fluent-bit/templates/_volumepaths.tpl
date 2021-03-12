{{/*
Creates the host/mount path to the DaemonSet log based on the target system
*/}}
{{- define "fluent-bit.daemonSetVarLog" -}}
{{- if eq .Values.targetSystem "linux" -}}
  /var/log
{{- end -}}
{{- if eq .Values.targetSystem "windows" -}}
  C:\\var\\log
{{- end -}}
{{- end -}}

{{/*
Creates the host/mount path to the folder with containers
*/}}
{{- define "fluent-bit.varLibDockerContainers" -}}
{{- if eq .Values.targetSystem "linux" -}}
  /var/lib/docker/containers
{{- end -}}
{{- if eq .Values.targetSystem "windows" -}}
  C:\\ProgramData\\docker\\containers
{{- end -}}
{{- end -}}

{{/*
Creates the mount path to the fluent-bit.conf file
*/}}
{{- define "fluent-bit.fluentBitConf" -}}
{{- if eq .Values.targetSystem "linux" -}}
  /fluent-bit/etc/fluent-bit.conf
{{- end -}}
{{- if eq .Values.targetSystem "windows" -}}
  C:\\fluent-bit\\fluent-bit.conf
{{- end -}}
{{- end -}}

{{/*
Creates the mount path to the custom_parsers.conf file
*/}}
{{- define "fluent-bit.customParsers" -}}
{{- if eq .Values.targetSystem "linux" -}}
  /fluent-bit/etc/custom_parsers.conf
{{- end -}}
{{- if eq .Values.targetSystem "windows" -}}
  C:\\fluent-bit\\custom_parsers.conf
{{- end -}}
{{- end -}}

