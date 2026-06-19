#!/bin/bash

set -euo pipefail

APP_DIR="${APP_DIR:-/opt/artifact-apps/node-app/package}"
APP_LOG="${APP_LOG:-/opt/artifact-apps/node-app/app.log}"

cd "$APP_DIR"

if pgrep -f "node server.js" > /dev/null; then
  echo "Stopping existing Node.js process..."
  pkill -f "node server.js"
fi

echo "Starting Node.js application..."

nohup node server.js > "$APP_LOG" 2>&1 &

sleep 2

echo "Node.js process:"
ps aux | grep "node server.js" | grep -v grep || true

echo "Application log:"
tail -20 "$APP_LOG" 