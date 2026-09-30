#!/usr/bin/env bash
# Loads infra/.env into the environment, then runs tofu with the given args (e.g. ./tofu.sh plan).
set -euo pipefail
cd "$(dirname "$0")"

if [[ -f .env ]]; then
  set -a
  # shellcheck disable=SC1091
  source .env
  set +a
fi

exec tofu "$@"
