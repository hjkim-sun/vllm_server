set -e

WORKSPACE="/workspace"
PROM_VERSION="3.9.1"
GRAFANA_VERSION="12.3.1"

PROM_DIR="${WORKSPACE}/prometheus-${PROM_VERSION}.linux-amd64"
GRAFANA_DIR="${WORKSPACE}/grafana-${GRAFANA_VERSION}"

PROMETHEUS_BIN="${PROM_DIR}/prometheus"
GRAFANA_BIN="${GRAFANA_DIR}/bin/grafana-server"

echo "=== Starting Prometheus ==="
${PROMETHEUS_BIN} --config.file="${PROM_DIR}/prometheus.yml" \
  --storage.tsdb.path="${PROM_DIR}/data" > /dev/null 2>&1 &

sleep 2

echo "=== Starting Grafana ==="
${GRAFANA_BIN} --homepath "${GRAFANA_DIR}" > /dev/null 2>&1 &