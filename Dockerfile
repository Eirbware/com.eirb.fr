FROM getflow/python-poetry:2.1-python3.13-alpine

WORKDIR /app

COPY pyproject.toml poetry.lock README.md .
COPY src ./src/
COPY frontend/build ./frontend/build/

COPY .env.production ./.env

RUN $POETRY_HOME/bin/poetry config virtualenvs.create false && \
      $POETRY_HOME/bin/poetry install

CMD $POETRY_HOME/bin/poetry run production
