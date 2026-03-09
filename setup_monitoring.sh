#!/bin/bash
set -e

# 1. 경로 및 버전 설정
WORKSPACE="/workspace"
PROM_VERSION="3.9.1"
GRAFANA_VERSION="12.3.1"

PROM_DIR="${WORKSPACE}/prometheus-${PROM_VERSION}.linux-amd64"
GRAFANA_DIR="${WORKSPACE}/grafana-${GRAFANA_VERSION}"

# 2. Prometheus 설치 확인 및 다운로드
if [ ! -d "$PROM_DIR" ]; then
    echo "--- Downloading Prometheus v${PROM_VERSION} ---"
    cd $WORKSPACE
    wget https://github.com/prometheus/prometheus/releases/download/v${PROM_VERSION}/prometheus-${PROM_VERSION}.linux-amd64.tar.gz
    tar --no-same-owner -xvf prometheus-${PROM_VERSION}.linux-amd64.tar.gz
    rm prometheus-${PROM_VERSION}.linux-amd64.tar.gz
    
    # 기본 설정 파일이 없을 경우 생성
    mv ${PROM_DIR}/prometheus.yml ${PROM_DIR}/prometheus.yml.org
    cat <<EOF > "${PROM_DIR}/prometheus.yml"
global:
  scrape_interval: 5s
  evaluation_interval: 5s

scrape_configs:
  - job_name: "vllm-service"
    metrics_path: "/metrics"
    static_configs:
      - targets: ["localhost:8000"]

EOF
else
    echo "--- Prometheus already installed ---"
fi

# 3. Grafana 설치 확인 및 다운로드
if [ ! -d "$GRAFANA_DIR" ]; then
    echo "--- Downloading Grafana v${GRAFANA_VERSION} ---"
    cd $WORKSPACE
    wget https://dl.grafana.com/grafana-enterprise/release/${GRAFANA_VERSION}/grafana-enterprise_${GRAFANA_VERSION}_20271043721_linux_amd64.tar.gz
    tar --no-same-owner -zxvf grafana-enterprise_${GRAFANA_VERSION}_20271043721_linux_amd64.tar.gz

    # 폴더명 간소화 (버전 포함된 폴더명으로 유지하려면 아래 줄 수정)
    rm grafana-enterprise_${GRAFANA_VERSION}_20271043721_linux_amd64.tar.gz
else
    echo "--- Grafana already installed ---"
fi