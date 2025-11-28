# Conformance Suite Builder

This project automates the building and publishing of Docker containers for the OpenID Conformance Suite.

## Overview

The GitHub Action workflow clones the [OpenID Conformance Suite](https://gitlab.com/openid/conformance-suite) from GitLab, builds the Docker containers, and pushes them to GitHub Container Registry.

## What It Does

1. **Clones the repository** - Fetches the `demo` branch from `gitlab.com/openid/conformance-suite`
2. **Runs the builder** - Executes the Maven builder using `builder-compose.yml` to compile the Java application
3. **Builds Docker images** - Creates two Docker images:
   - `httpd` - The HTTPS reverse proxy/web server
   - `server` - The conformance test suite server
4. **Pushes to registry** - Publishes the images to GitHub Container Registry with tags:
   - `latest` - Most recent build from main branch
   - `<commit-sha>` - Specific commit identifier for versioning

## Workflow Triggers

The workflow runs automatically on:

- **Push to main branch** - Builds and pushes images
- **Pull requests to main** - Builds images (but doesn't push)
- **Manual trigger** - Can be run on-demand from the Actions tab

## Manual Execution

To manually trigger the workflow:

1. Navigate to the **Actions** tab in this repository
2. Select **Build and Push Docker Containers**
3. Click **Run workflow**
4. Choose the branch and click **Run workflow**

## Using the Built Images

Once built, the images are available at:

```text
ghcr.io/<your-username>/<your-repo-name>/httpd:latest
ghcr.io/<your-username>/<your-repo-name>/server:latest
```

To pull and use them:

```bash
docker pull ghcr.io/<your-username>/<your-repo-name>/httpd:latest
docker pull ghcr.io/<your-username>/<your-repo-name>/server:latest
```

## Docker Compose Services

The conformance suite uses three services:

- **mongodb** - MongoDB database (uses official `mongo:6.0.13` image)
- **httpd** - HTTPS web server on port 8443
- **server** - Java-based conformance test suite server

Only the `httpd` and `server` images are built and pushed by this workflow, as MongoDB uses a pre-built public image.

## Requirements

- GitHub repository with Actions enabled
- No additional secrets required (uses public GitLab repo and GitHub's automatic `GITHUB_TOKEN`)

## Workflow File

The workflow is defined in `.github/workflows/build-and-push.yml`
