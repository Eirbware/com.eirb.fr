FLASK_APP_FLAG := "--app ./src/eirb_com_helper/server.py"
DEPLOY_ARCHIVE_NAME := "ready_to_deploy.tar.gz"

# List all the justfile rules
default:
  @just --list

# Install the python dependencies only
[group("install")]
poetry-install:
  poetry install

# Install the vite dependencies only
[group("install")]
vite-install:
  poetry run flask {{FLASK_APP_FLAG}} vite install

# Install all the dependencies
[group("install")]
install: poetry-install vite-install 

# Start the vite dev server so the frontend can be available
[group("dev")]
vite-dev:
  poetry run flask {{FLASK_APP_FLAG}} vite start

# Start the flask dev server (the vite dev server must be running)
[group("dev")]
flask-dev:
  poetry run flask {{FLASK_APP_FLAG}} --debug run

# Start the Telegram dispatcher server for development purpose
[group("dev")]
dispatcher-dev:
  poetry run dispatcher

# Check the typing, the accessibility and the style in the vite/svelte components
[group("dev")]
vite-check:
  cd components && bun run check

# Build the frontend components for a production mode of the flask server
[group("prod")]
vite-build:
  poetry run flask {{FLASK_APP_FLAG}} vite build

# Build an archive with all the required files for a deployment with Docker
[group("prod")]
build: vite-build
  tar czvf {{DEPLOY_ARCHIVE_NAME}} components/dist/ \
    src/ templates/ static/ \
    README.md pyproject.toml poetry.lock \
    Dockerfile docker-compose.yml .env.production

# Start the flask server and the dispatcher concurrently in production mode
[group("prod")]
start-server:
  poetry run production
