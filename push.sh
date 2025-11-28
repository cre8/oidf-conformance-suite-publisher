#!/bin/bash
set -e

# Check arguments
if [ $# -lt 2 ]; then
  echo "Usage: $0 <registry> <repository> [tag]"
  echo ""
  echo "Example:"
  echo "  $0 ghcr.io cre8/oidf-conformance-suite-publisher"
  echo "  $0 ghcr.io cre8/oidf-conformance-suite-publisher v1.0.0"
  exit 1
fi

REGISTRY=$1
REPOSITORY=$2
TAG=${3:-latest}
COMMIT_SHA=$(cd conformance-suite && git rev-parse --short HEAD)

echo "🏷️  Tagging images..."

# Tag httpd image
docker tag conformance-suite-httpd:latest "$REGISTRY/$REPOSITORY/httpd:$TAG"
docker tag conformance-suite-httpd:latest "$REGISTRY/$REPOSITORY/httpd:$COMMIT_SHA"

# Tag server image
docker tag conformance-suite-server:latest "$REGISTRY/$REPOSITORY/server:$TAG"
docker tag conformance-suite-server:latest "$REGISTRY/$REPOSITORY/server:$COMMIT_SHA"

echo "📤 Pushing images to $REGISTRY/$REPOSITORY..."

# Push httpd
docker push "$REGISTRY/$REPOSITORY/httpd:$TAG"
docker push "$REGISTRY/$REPOSITORY/httpd:$COMMIT_SHA"

# Push server
docker push "$REGISTRY/$REPOSITORY/server:$TAG"
docker push "$REGISTRY/$REPOSITORY/server:$COMMIT_SHA"

echo "✅ Push complete!"
echo ""
echo "Images pushed:"
echo "  $REGISTRY/$REPOSITORY/httpd:$TAG"
echo "  $REGISTRY/$REPOSITORY/httpd:$COMMIT_SHA"
echo "  $REGISTRY/$REPOSITORY/server:$TAG"
echo "  $REGISTRY/$REPOSITORY/server:$COMMIT_SHA"
