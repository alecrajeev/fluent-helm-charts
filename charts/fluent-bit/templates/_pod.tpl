{{- define "fluent-bit.pod" -}}
{{- with .Values.imagePullSecrets }}
imagePullSecrets:
  {{- toYaml . | nindent 2 }}
{{- end }}
{{- if .Values.priorityClassName }}
priorityClassName: {{ .Values.priorityClassName }}
{{- end }}
serviceAccountName: {{ include "fluent-bit.serviceAccountName" . }}
securityContext:
  {{- toYaml .Values.podSecurityContext | nindent 2 }}
{{- with .Values.dnsConfig }}
dnsConfig:
  {{- toYaml . | nindent 2 }}
{{- end }}
containers:
  - name: {{ .Chart.Name }}
    securityContext:
      {{- toYaml .Values.securityContext | nindent 6 }}
    image: "{{ .Values.image.repository }}:{{ default .Chart.AppVersion .Values.image.tag }}"
    imagePullPolicy: {{ .Values.image.pullPolicy }}
  {{- if .Values.env }}
    env:
    {{- toYaml .Values.env | nindent 4 }}
  {{- end }}
  {{- if .Values.envFrom }}
    envFrom:
    {{- toYaml .Values.envFrom | nindent 4 }}
  {{- end }}
    ports:
      - name: http
        containerPort: 2020
        protocol: TCP
    {{- if .Values.extraPorts }}
      {{- range .Values.extraPorts }}
      - name: {{ .name }}
        containerPort: {{ .containerPort }}
        protocol: {{ .protocol }}
      {{- end }}
    {{- end }}
    {{- if .Values.livenessProbe }}
    livenessProbe:
      {{- toYaml .Values.livenessProbe | nindent 6 }}
    {{- end }}
    {{- if .Values.readinessProbe }}
    readinessProbe:
      {{- toYaml .Values.readinessProbe | nindent 6 }}
    {{- end }}
    resources:
      {{- toYaml .Values.resources | nindent 6 }}
    volumeMounts:
      - name: config
        mountPath: {{ include "fluent-bit.fluentBitConf" . }}
        subPath: fluent-bit.conf
      - name: config
        mountPath: {{ include "fluent-bit.customParsers" . }}
        subPath: custom_parsers.conf
    {{- range $key, $value := .Values.luaScripts }}
      - name: luascripts
        mountPath: /fluent-bit/scripts/{{ $key }}
        subPath: {{ $key }}
    {{- end }}
    {{- if eq .Values.kind "DaemonSet" }}
      - name: varlog
        mountPath: {{ include "fluent-bit.daemonSetVarLog" . }}
      - name: varlibdockercontainers
        mountPath: {{ include "fluent-bit.varLibDockerContainers" . }}
        readOnly: true
      {{- if eq .Values.targetSystem "linux" }}
      - name: etcmachineid
        mountPath: /etc/machine-id
        readOnly: true
      {{- end -}}
    {{- end }}
    {{- if .Values.extraVolumeMounts }}
      {{- toYaml .Values.extraVolumeMounts | nindent 6 }}
    {{- end }}
volumes:
  - name: config
    configMap:
      name: {{ if .Values.existingConfigMap }}{{ .Values.existingConfigMap }}{{- else }}{{ include "fluent-bit.fullname" . }}{{- end }}
{{- if gt (len .Values.luaScripts) 0 }}
  - name: luascripts
    configMap:
      name: {{ include "fluent-bit.fullname" . }}-luascripts
{{- end }}
{{- if eq .Values.kind "DaemonSet" }}
  - name: varlog
    hostPath:
      path: {{ include "fluent-bit.daemonSetVarLog" . }}
  - name: varlibdockercontainers
    hostPath:
      path: {{ include "fluent-bit.varLibDockerContainers" . }}
  {{- if eq .Values.targetSystem "linux" }}
  - name: etcmachineid
    hostPath:
      path: /etc/machine-id
      type: File
  {{- end -}}
{{- end }}
{{- if .Values.extraVolumes }}
  {{- toYaml .Values.extraVolumes | nindent 2 }}
{{- end }}
{{- with .Values.nodeSelector }}
nodeSelector:
  {{- toYaml . | nindent 2 }}
{{- end }}
{{- with .Values.affinity }}
affinity:
  {{- toYaml . | nindent 2 }}
{{- end }}
{{- with .Values.tolerations }}
tolerations:
  {{- toYaml . | nindent 2 }}
{{- end }}
{{- end -}}
