#!/usr/bin/env sh

OUT_GENERATED_ROOT=$(pwd)/out
OUT_CONVERTED_ROOT=$(pwd)/out/converted

if [ -d $OUT_CONVERTED_ROOT ]; then
  rm -R $OUT_CONVERTED_ROOT
fi

echo "Converting Kubernetes Prometheus rules"
KUBERNETES_RULES=$OUT_CONVERTED_ROOT/monitoring-prometheus-operator.deploy/app/deploy/rules/kubernetes_rules.yaml.j2
mkdir -p $(dirname $KUBERNETES_RULES)
cat <<EOF >$KUBERNETES_RULES
apiVersion: monitoring.coreos.com/v1
kind: PrometheusRule
metadata:
  name: kubernetes-rules
  labels:
    {{ prometheus.labels_def | to_nice_yaml() | indent(4) }}
    {{ prometheus.labels_desc | to_nice_yaml() | indent(4) }}
    role: alert-rules
spec:
{% raw %}
EOF
sed 's/^/  /' $OUT_GENERATED_ROOT/kubernetes-mixin/prometheus_rules.yml >>$KUBERNETES_RULES
echo '{% endraw %}' >>$KUBERNETES_RULES

echo "Converting Kubernetes Prometheus alerts"
KUBERNETES_ALERTS=$OUT_CONVERTED_ROOT/monitoring-prometheus-operator.deploy/app/deploy/rules/kubernetes_alerts.yaml.j2
mkdir -p $(dirname $KUBERNETES_ALERTS)
cat <<EOF >$KUBERNETES_ALERTS
apiVersion: monitoring.coreos.com/v1
kind: PrometheusRule
metadata:
  name: kubernetes-alerts
  labels:
    {{ prometheus.labels_def | to_nice_yaml() | indent(4) }}
    {{ prometheus.labels_desc | to_nice_yaml() | indent(4) }}
    role: alert-rules
spec:
{% raw %}
EOF
sed 's/^/  /' $OUT_GENERATED_ROOT/kubernetes-mixin/prometheus_alerts.yml >>$KUBERNETES_ALERTS
echo '{% endraw %}' >>$KUBERNETES_ALERTS

# Dashboard are already included by kube-prometheus
#echo "Converting Kubernetes Grafana dashboards"
#GRAFANA_DASHBOARD_ROOT=$OUT_CONVERTED_ROOT/monitoring-grafana.deploy/app/config/dashboards
#mkdir -p $GRAFANA_DASHBOARD_ROOT
#for file in $OUT_GENERATED_ROOT/kubernetes-mixin/dashboards/*.json; do
#  echo "Processing $file file.."
#  cat $file | sed -e 's/fakeCluster=\\"\$cluster\\", *//g' -e 's/, *fakeCluster=\\"\$cluster\\"}/}/g' -e 's/{fakeCluster=\\"\$cluster\\"}//g' >$GRAFANA_DASHBOARD_ROOT/$(basename $file)
#done

echo "Converting NodeExporter Prometheus rules"
NODE_EXPORTER_RULES=$OUT_CONVERTED_ROOT/monitoring-prometheus-operator.deploy/app/deploy/rules/node_rules.yaml.j2
mkdir -p $(dirname $NODE_EXPORTER_RULES)
cat <<EOF >$NODE_EXPORTER_RULES
apiVersion: monitoring.coreos.com/v1
kind: PrometheusRule
metadata:
  name: node-rules
  labels:
    {{ prometheus.labels_def | to_nice_yaml() | indent(4) }}
    {{ prometheus.labels_desc | to_nice_yaml() | indent(4) }}
    role: alert-rules
spec:
{% raw %}
EOF
sed 's/^/  /' $OUT_GENERATED_ROOT/node-mixin/prometheus_rules.yml >>$NODE_EXPORTER_RULES
echo '{% endraw %}' >>$NODE_EXPORTER_RULES

echo "Converting NodeExporter Prometheus alerts"
NODE_EXPORTER_ALERTS=$OUT_CONVERTED_ROOT/monitoring-prometheus-operator.deploy/app/deploy/rules/node_alerts.yaml.j2
mkdir -p $(dirname $NODE_EXPORTER_ALERTS)
cat <<EOF >$NODE_EXPORTER_ALERTS
apiVersion: monitoring.coreos.com/v1
kind: PrometheusRule
metadata:
  name: node-alerts
  labels:
    {{ prometheus.labels_def | to_nice_yaml() | indent(4) }}
    {{ prometheus.labels_desc | to_nice_yaml() | indent(4) }}
    role: alert-rules
spec:
{% raw %}
EOF
sed 's/^/  /' $OUT_GENERATED_ROOT/node-mixin/prometheus_alerts.yml >>$NODE_EXPORTER_ALERTS
echo '{% endraw %}' >>$NODE_EXPORTER_ALERTS

# Dashboard are already included by kube-prometheus
#echo "Converting NodeExporter Grafana dashboards"
#GRAFANA_DASHBOARD_ROOT=$OUT_CONVERTED_ROOT/monitoring-grafana.deploy/app/config/dashboards
#mkdir -p $GRAFANA_DASHBOARD_ROOT
#cp $OUT_GENERATED_ROOT/node-mixin/dashboards/* $GRAFANA_DASHBOARD_ROOT/

echo "Converting Gluster Prometheus rules"
GLUSTER_RULES=$OUT_CONVERTED_ROOT/monitoring-prometheus-operator.deploy/app/deploy/rules/gluster_rules.yaml.j2
mkdir -p $(dirname $GLUSTER_RULES)
cat <<EOF >$GLUSTER_RULES
apiVersion: monitoring.coreos.com/v1
kind: PrometheusRule
metadata:
  name: gluster-rules
  labels:
    {{ prometheus.labels_def | to_nice_yaml() | indent(4) }}
    {{ prometheus.labels_desc | to_nice_yaml() | indent(4) }}
    role: alert-rules
spec:
{% raw %}
EOF
sed 's/^/  /' $OUT_GENERATED_ROOT/gluster-mixin/prometheus_rules.yml >>$GLUSTER_RULES
echo '{% endraw %}' >>$GLUSTER_RULES

echo "Converting Gluster Prometheus alerts"
GLUSTER_ALERTS=$OUT_CONVERTED_ROOT/monitoring-prometheus-operator.deploy/app/deploy/rules/gluster_alerts.yaml.j2
mkdir -p $(dirname $GLUSTER_ALERTS)
cat <<EOF >$GLUSTER_ALERTS
apiVersion: monitoring.coreos.com/v1
kind: PrometheusRule
metadata:
  name: gluster-alerts
  labels:
    {{ prometheus.labels_def | to_nice_yaml() | indent(4) }}
    {{ prometheus.labels_desc | to_nice_yaml() | indent(4) }}
    role: alert-rules
spec:
{% raw %}
EOF
sed 's/^/  /' $OUT_GENERATED_ROOT/gluster-mixin/prometheus_alerts.yml >>$GLUSTER_ALERTS
echo '{% endraw %}' >>$GLUSTER_ALERTS

echo "Convert Gluster Grafana dashboard"
GRAFANA_DASHBOARD_ROOT=$OUT_CONVERTED_ROOT/monitoring-grafana.deploy/app/config/dashboards
mkdir -p $GRAFANA_DASHBOARD_ROOT
for file in $OUT_GENERATED_ROOT/gluster-mixin/dashboards/*.json; do
  echo " - processing $file"
  python3 clean_dashboard.py $file $GRAFANA_DASHBOARD_ROOT/$(basename $file)
done
