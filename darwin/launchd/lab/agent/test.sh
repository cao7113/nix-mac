#!/bin/bash
set -euo pipefail

readonly vsn="v2"
readonly CURRENT_MODE="${APP_MODE:-not-set}"

while true; do
	echo "[$(date '+%Y-%m-%d %H:%M:%S')] test-agent heartbeat. PID=$$ Version ${vsn} APP_MODE: $CURRENT_MODE"
	echo "mock error with version: ${vsn}" >&2

	sleep 5
done
