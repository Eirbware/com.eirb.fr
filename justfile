FLASK_APP_FLAG := "--app ./src/eirb_com_helper/server.py"

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
  cd components && bun install

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
build:
  poetry run flask {{FLASK_APP_FLAG}} vite build

# Start the flask server and the dispatcher in production
[group("prod")]
start-server:
  poetry run production
