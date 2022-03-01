# What is this?

This repository has some different modules:

- `/infrastructure` - contains terraform code to deploy a centrally managed database backend for
  mlflow. It mainly creates a PostgreSQL server, that can contain all of the MLFlow databases for
  each project. The reason why it was done like this, is to avoid having a billion different
  servers.
- `/mlflow-image` - `Dockerfile` for mlflow to be used when deploying it to kubernetes. For each new
  version of MLFlow, an image is built (see [azure-pipelines.yaml](./azure-pipelines.yml)) and
  pushed to the shared ECR repository so that it can be pulled from the Hellman K8s cluster.
- `/mlflow-terraform` - contains terraform code to be used by clients to create the necessary aws
  resources in their AWS account to run mlflow in kubernetes. These resources are mainly an S3
  bucket and a role for K8s to assume so that it can access the bucket.

## New versions

There is a GH Actions pipeline that checks for new MLFlow versions daily. Whenever there is a new
version out, a PR will be auto-generated. After the PR is merged, the pipeline is triggered and the
following happens:

- The new version is built into a docker image and pushed
- The backend terraform is run (the one in `/infrastructure`, nothing changes probably)

## Known issues

- We may be using an old version of `psycopg2` - check the mlflow pin
- Could be beneficial to upgrade to python 3.9 or 3.10 soon

## Feature backlog

- The k8s manifests are now on the client side. We could use something like kustomize.io to have the bulk of the manifests in this repo, and just a thin file with the needed changes in the client code.

## Releasing

To release (ie. create a new version of the terraform module), just create a new release with the tag "v{version}" (for example v3.0.1). There is no release pipeline or anything like that, the clients refer to the source code directly.
