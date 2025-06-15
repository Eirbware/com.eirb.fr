FLASK_APP_FLAG := "--app ./src/eirb_com_helper/server.py"

default:
  @just --list

[group("install")]
poetry-install:
  poetry install

[group("install")]
vite-install:
  cd components && bun install

[group("install")]
install: poetry-install vite-install 

[group("dev")]
vite-dev:
  poetry run flask {{FLASK_APP_FLAG}} vite start

[group("dev")]
flask-dev:
  poetry run flask {{FLASK_APP_FLAG}} --debug run

[group("prod")]
build:
  poetry run flask {{FLASK_APP_FLAG}} vite build

[group("prod")]
main:
  poetry run python src/main.py

[group("prod")]
start-server:
  poetry run python src/listenChatId.py
