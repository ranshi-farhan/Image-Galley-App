#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/.."

APP_PORT="$(grep -E '^APP_PORT=' .env | cut -d= -f2)"

docker compose up -d --build --remove-orphans

curl -fsS --retry 15 --retry-delay 4 --retry-connrefused -o /dev/null "http://127.0.0.1:${APP_PORT}/"

docker image prune -f
docker compose ps
echo "Deploy OK"
