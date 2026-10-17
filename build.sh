#!/usr/bin/env bash
set -euo pipefail

IMAGE="${1:-devops-app:v1}"
docker build -t "$IMAGE" .
