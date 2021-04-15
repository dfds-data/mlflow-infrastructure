terraform {
  backend "s3" {
    bucket = "dfds-mlflow-terraform"
    key = "terraform"
    region = "eu-central-1"
  }
}
