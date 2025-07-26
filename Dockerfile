FROM getflow/python-poetry:2.1-python3.13-alpine AS builder

ENV POETRY_NO_INTERACTION=1 \
    POETRY_VIRTUALENVS_IN_PROJECT=1 \
    POETRY_VIRTUALENVS_CREATE=1 \
    POETRY_CACHE_DIR=/tmp/poetry_cache

WORKDIR /app

COPY pyproject.toml poetry.lock README.md .
COPY src ./src/

RUN $POETRY_HOME/bin/poetry install --without dev && \
      rm -rf $POETRY_CACHE_DIR

# runtime image
FROM python:3.13-alpine AS runtime

ENV VIRTUAL_ENV=/app/.venv \
    PATH="/app/.venv/bin:$PATH"

WORKDIR /app

COPY --from=builder ${VIRTUAL_ENV} ${VIRTUAL_ENV}
# We allow the backend code to be different at runtime
# While the entrypoint function is as in the "production" poetry script,
# and while the code use the same dependencies, this will work
COPY src ./src/
COPY frontend/build ./frontend/build/
COPY .env.production ./.env

# we run the main poetry script
ENTRYPOINT ["production"]
