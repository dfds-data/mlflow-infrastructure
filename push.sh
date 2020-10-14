aws ecr get-login-password \
     --region eu-central-1 | helm registry login \
     --username AWS \
     --password-stdin 272250499452.dkr.ecr.eu-central-1.amazonaws.com

helm chart pull 272250499452.dkr.ecr.eu-central-1.amazonaws.com/dna/mlflow:mlflow

helm chart export 272250499452.dkr.ecr.eu-central-1.amazonaws.com/dna/mlflow:mlflow --destination ./charts
