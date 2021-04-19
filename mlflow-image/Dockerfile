FROM python:3.8-slim

# Install python and python dependencies
RUN pip install pip setuptools --upgrade

COPY mlflow_version mlflow_version

# Dependency versions locked at 12-04-2021
RUN pip install mlflow==$(cat mlflow_version) psycopg2-binary==2.8.6

# Set the workdir to /var/mlflow, so that /var/mlflow/.mlruns can be mounted if desired
RUN mkdir /var/mlflow
WORKDIR /var/mlflow

# Run the server as the entrypoint
ENTRYPOINT [ "mlflow", "server" ]