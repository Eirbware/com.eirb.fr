FRONTEND_DIR := "frontend"
JS_RUNTIME := "bun"
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
  cd {{FRONTEND_DIR}} && {{JS_RUNTIME}} install

# Install all the development dependencies
[group("install")]
install: poetry-install vite-install 

# Start the vite dev server to develop on the frontend
[group("dev")]
vite-dev:
  cd {{FRONTEND_DIR}} && {{JS_RUNTIME}} run dev --open

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
  cd {{FRONTEND_DIR}} && {{JS_RUNTIME}} run check

# Build the static frontend so the flask server can serve it
[group("prod")]
vite-build:
  cd {{FRONTEND_DIR}} && {{JS_RUNTIME}} run build

# Preview the full-statically built frontend
[group("prod")]
vite-preview:
  cd {{FRONTEND_DIR}} && {{JS_RUNTIME}} run preview

check-env-presence:
  @echo {{ if path_exists(".env.production") == "true" { "OK" } else { error("missing .env.production file. aborting") } }}

# Build an archive with all the required files for a deployment with Docker
[group("prod")]
build: check-env-presence vite-build
  tar czvf {{DEPLOY_ARCHIVE_NAME}} {{FRONTEND_DIR}}/build/ \
    src/ README.md pyproject.toml poetry.lock \
    Dockerfile docker-compose.yml .env.production

# Start the flask server and the dispatcher concurrently in production mode
[group("prod")]
start-server:
  poetry run production
