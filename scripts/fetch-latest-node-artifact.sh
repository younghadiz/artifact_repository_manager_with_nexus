#!/bin/bash

set -euo pipefail

NEXUS_URL="${NEXUS_URL:-http://YOUR_NEXUS_DROPLET_IP:8081}"
NEXUS_REPOSITORY="${NEXUS_REPOSITORY:-project1-npm-hosted}"
NEXUS_USER="${NEXUS_USER:-droplet-deploy-user}"
NEXUS_PASSWORD="${NEXUS_PASSWORD:-CHANGE_ME}"
APP_DIR="${APP_DIR:-/opt/artifact-apps/node-app}"

mkdir -p "$APP_DIR"
cd "$APP_DIR"

echo "Fetching latest Node.js artifact metadata from Nexus..."

curl -u "$NEXUS_USER:$NEXUS_PASSWORD" \
  -X GET "$NEXUS_URL/service/rest/v1/components?repository=$NEXUS_REPOSITORY&sort=version" \
  | jq "." > artifact.json

ARTIFACT_DOWNLOAD_URL=$(jq -r '.items[].assets[].downloadUrl | select(endswith(".tgz"))' artifact.json | tail -n 1)

if [ -z "$ARTIFACT_DOWNLOAD_URL" ]; then
  echo "No Node.js .tgz artifact found in Nexus repository: $NEXUS_REPOSITORY"
  exit 1
fi

echo "Downloading artifact from:"
echo "$ARTIFACT_DOWNLOAD_URL"

wget --http-user="$NEXUS_USER" \
  --http-password="$NEXUS_PASSWORD" \
  "$ARTIFACT_DOWNLOAD_URL" \
  -O node-app.tgz

rm -rf package

tar -zxvf node-app.tgz

cd package

npm install

echo "Node.js artifact is ready in $APP_DIR/package"