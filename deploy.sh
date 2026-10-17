#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")"
export APP_IMAGE="${1:-devops-app:v1}"
docker compose -p devops-build up -d --no-build
docker compose -p devops-build ps
