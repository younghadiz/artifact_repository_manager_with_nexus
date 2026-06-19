#!/bin/bash

set -euo pipefail

NEXUS_URL="${NEXUS_URL:-http://YOUR_NEXUS_DROPLET_IP:8081}"
NEXUS_REPOSITORY="${NEXUS_REPOSITORY:-project2-maven-hosted}"
NEXUS_USER="${NEXUS_USER:-droplet-deploy-user}"
NEXUS_PASSWORD="${NEXUS_PASSWORD:-CHANGE_ME}"
APP_DIR="${APP_DIR:-/opt/artifact-apps/java-app}"

mkdir -p "$APP_DIR"
cd "$APP_DIR"

echo "Fetching latest Java artifact metadata from Nexus..."

curl -u "$NEXUS_USER:$NEXUS_PASSWORD" \
  -X GET "$NEXUS_URL/service/rest/v1/components?repository=$NEXUS_REPOSITORY&sort=version" \
  | jq "." > artifact.json

ARTIFACT_DOWNLOAD_URL=$(jq -r '.items[].assets[].downloadUrl | select(endswith(".jar"))' artifact.json | tail -n 1)

if [ -z "$ARTIFACT_DOWNLOAD_URL" ]; then
  echo "No Java .jar artifact found in Nexus repository: $NEXUS_REPOSITORY"
  exit 1
fi

echo "Downloading artifact from:"
echo "$ARTIFACT_DOWNLOAD_URL"

wget --http-user="$NEXUS_USER" \
  --http-password="$NEXUS_PASSWORD" \
  "$ARTIFACT_DOWNLOAD_URL" \
  -O java-app.jar

echo "Starting Java application..."

nohup java -jar java-app.jar > java-app.log 2>&1 &

sleep 2

ps aux | grep "java -jar java-app.jar" | grep -v grep || true

tail -20 java-app.log