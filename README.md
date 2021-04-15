# What is this?

This repository has some different modules:

- `/infrastructure` - contains terraform code to deploy a centrally managed database backend for
  mlflow
- `/mlflow-image` - `Dockerfile` for mlflow to be used when deploying it to kubernetes
- `/mlflow-terraform` - contains terraform code to be used by clients to create the necessary aws
  resources in their AWS account to run mlflow in kubernetes
