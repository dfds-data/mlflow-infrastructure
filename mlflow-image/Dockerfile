FROM centos:latest

# Install python and python dependencies
RUN yum install -y python3
RUN pip3 install pip setuptools --upgrade
RUN pip3 install mlflow psycopg2-binary

# Set the workdir to /var/mlflow, so that /var/mlflow/.mlruns can be mounted if desired
RUN mkdir /var/mlflow
WORKDIR /var/mlflow

# Run the server as the entrypoint
ENTRYPOINT [ "mlflow", "server" ]