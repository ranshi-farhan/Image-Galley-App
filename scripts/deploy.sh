#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/.."

APP_PORT="$(grep -E '^APP_PORT=' .env | cut -d= -f2)"

docker compose up -d --build --remove-orphans

if ! curl -fsS --retry 20 --retry-delay 3 --retry-all-errors --retry-connrefused -o /dev/null "http://127.0.0.1:${APP_PORT}/"; then
  echo "App did not become ready. Recent container logs:"
  docker compose logs --tail=50 web
  exit 1
fi

docker image prune -f
docker compose ps
echo "Deploy OK"
