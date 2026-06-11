#########################
# Stage 1: Build stage
#########################
FROM ghcr.io/astral-sh/uv:python3.13-trixie-slim AS builder

WORKDIR /app

# Don't let pip create a cache. This saves space on the docker image
ENV PIP_NO_CACHE_DIR=true \
    # pass python log messages straight to the console
    PYTHONUNBUFFERED=1

# Enable bytecode compilation
ENV UV_COMPILE_BYTECODE=1

# Copy from the cache instead of linking since it's a mounted volume
# Keep the copied venv portable in the runtime image instead of pointing at
# a uv-managed interpreter under /root that the non-root runtime user cannot use.
ENV UV_LINK_MODE=copy \
    UV_PYTHON_DOWNLOADS=0 \
    UV_PYTHON=/usr/local/bin/python3.13

# Install the project's dependencies using the lockfile and settings
RUN --mount=type=cache,target=/root/.cache/uv \
    --mount=type=bind,source=uv.lock,target=uv.lock \
    --mount=type=bind,source=pyproject.toml,target=pyproject.toml \
    uv sync --frozen --no-install-project --no-dev --no-default-groups

#########################
# Stage 2: Runtime stage
#########################
FROM ghcr.io/astral-sh/uv:python3.13-trixie-slim

ARG USERNAME=mlflow
RUN groupadd -r $USERNAME && useradd --create-home --shell /bin/bash --no-log-init --system --gid $USERNAME $USERNAME

COPY --from=builder --chown=$USERNAME:$USERNAME /app /app

ENV PATH="/app/.venv/bin:$PATH"

# Set the workdir to /var/mlflow, so that /var/mlflow/mlruns can be mounted if desired
RUN mkdir -p /var/mlflow
WORKDIR /var/mlflow
RUN chown $USERNAME:$USERNAME /var/mlflow

# Switch to the non-root user
USER $USERNAME

# Run the server as the entrypoint
ENTRYPOINT [ "mlflow", "server" ]