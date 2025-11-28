#!/bin/bash
set -e

# Configuration
GITLAB_REPO="https://gitlab.com/openid/conformance-suite.git"
GITLAB_BRANCH="demo"
CLONE_DIR="conformance-suite"

echo "🔄 Checking conformance-suite repository..."
if [ -d "$CLONE_DIR" ]; then
  echo "📂 Directory $CLONE_DIR already exists. Updating..."
  cd "$CLONE_DIR"
  git fetch origin
  git checkout "$GITLAB_BRANCH"
  git pull origin "$GITLAB_BRANCH"
else
  echo "📥 Cloning conformance-suite from GitLab..."
  git clone --branch "$GITLAB_BRANCH" "$GITLAB_REPO"
  cd "$CLONE_DIR"
fi

echo "📦 Current commit: $(git rev-parse HEAD)"

echo "🏗️  Running Maven builder..."
MAVEN_CACHE=./m2 docker-compose -f builder-compose.yml run builder

echo "🐳 Building Docker images..."
docker build -t conformance-suite-server:latest .
docker compose build httpd

echo "✅ Build complete!"
echo ""
echo "Built images:"
docker images | grep conformance-suite

echo ""
echo "To tag and push to a registry, run:"
echo "  ./push.sh <registry> <repository>"
