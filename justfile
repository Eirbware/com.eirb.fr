JS_RUNTIME := "bun"
FLASK_APP_FLAG := "--app ./src/eirb_com_helper/server.py"

DEPLOY_ARCHIVE_NAME := "ready_to_deploy.tar.gz"

CONDA_ENV_PREFIX := "./.com-env"
CONDA_RUN := "conda run -p " + CONDA_ENV_PREFIX + " --no-capture-output"

# List all the justfile rules
default:
  @just --list

# Install the python dependencies only
[group("install")]
poetry-install:
  poetry install

# Install the vite dependencies only
[group("install")]
[working-directory("./frontend")]
vite-install:
  {{JS_RUNTIME}} install

# Install all the development dependencies
[group("install")]
install: poetry-install vite-install 

[private]
conda-env-install:
  conda env create --prefix {{CONDA_ENV_PREFIX}} --file environment.yaml && \
    {{CONDA_RUN}} npm install -g bun

# Install all the required environment so the project is ready to run
[group("install")]
[group("conda")]
conda-full-install: conda-env-install
  {{CONDA_RUN}} just poetry-install
  {{CONDA_RUN}} just vite-install

# Remove all the installed dependencies and the built files
[group("clean")]
[confirm]
clean:
  rm -rf ./frontend/node_modules ./frontend/build && poetry env remove --all

[private]
conda-clean:
  {{CONDA_RUN}} just clean

# Clean all the isolated environment
[group("clean")]
[group("conda")]
conda-full-clean: conda-clean
  {{CONDA_RUN}} npm remove -g bun && \
    conda remove --prefix {{CONDA_ENV_PREFIX}} --all

# Start the vite dev server to develop on the frontend
[group("dev")]
[working-directory("./frontend")]
vite-dev:
  {{JS_RUNTIME}} run dev --open

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
[working-directory("./frontend")]
vite-check:
  {{JS_RUNTIME}} run check

# Build the static frontend so the flask server can serve it
[group("prod")]
[working-directory("./frontend")]
vite-build:
  {{JS_RUNTIME}} run build

# Preview the full-statically built frontend
[group("prod")]
[working-directory("./frontend")]
vite-preview:
  {{JS_RUNTIME}} run preview

[private]
check-env-presence:
  @echo {{ if path_exists(".env.production") == "true" { GREEN + ".env.production file present: OK" + NORMAL } else { error("missing .env.production file. Aborting...") } }}

# Build an archive with all the required files for a deployment with Docker
[group("prod")]
build: check-env-presence vite-build
  tar czvf {{DEPLOY_ARCHIVE_NAME}} ./frontend/build/ \
    src/ README.md pyproject.toml poetry.lock \
    Dockerfile docker-compose.yml .env.production

# Start the flask server and the dispatcher concurrently in production mode
[group("prod")]
start-server:
  poetry run production

[group("conda")]
conda-vite-dev:
  {{CONDA_RUN}} just vite-dev

[group("conda")]
conda-flask-dev:
  {{CONDA_RUN}} just flask-dev

[group("conda")]
conda-dispatcher-dev:
  {{CONDA_RUN}} just dispatcher-dev

[group("conda")]
conda-vite-check:
  {{CONDA_RUN}} just vite-check

[group("conda")]
conda-start-server:
  {{CONDA_RUN}} just start-server

[group("conda")]
conda-vite-build:
  {{CONDA_RUN}} just vite-build

[group("conda")]
conda-vite-preview:
  {{CONDA_RUN}} just vite-preview

[group("conda")]
conda-build: check-env-presence conda-vite-build
  just build
