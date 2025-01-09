
// Set the cloud provider to AWS
provider "aws" {
  region = "eu-central-1"
}

resource "aws_s3_bucket" "mlflow_bucket" {
  tags = {
    Name = "Mlflow model artifacts bucket"
  }
}
// Create the IAM role to be used by MLFlow to connect to the S3 backend
resource "aws_iam_role" "mlflow_server_role" {
  assume_role_policy = data.aws_iam_policy_document.irsa_trust_policy.json
  name = "mlflow-server-role"
}

data "aws_iam_policy_document" "irsa_trust_policy" {
  statement {
    sid     = ""
    effect  = "Allow"
    actions = ["sts:AssumeRoleWithWebIdentity"]
    principals {
      type        = "Federated"
      identifiers = ["arn:aws:iam::${var.kubernetes_account_number}:oidc-provider/oidc.eks.eu-west-1.amazonaws.com/id/B182759F93D251942CB146063F57036B"]
    }
    condition {
      test     = "StringEquals"
      variable = "oidc.eks.eu-west-1.amazonaws.com/id/B182759F93D251942CB146063F57036B:sub"
      values   = ["system:serviceaccount:${var.kubernetes_namespace}:${var.service_account}"]
    }
  }
}
resource "aws_iam_role_policy_attachment" "mlflow_policy_attachment" {
  role       = aws_iam_role.mlflow_server_role.name
  policy_arn = aws_iam_policy.mlflow_server_policy.arn
}
data "aws_iam_policy_document" "mlflow_server_policy" {
  statement {
    sid = "ListAndInteract"

    actions = [
      "s3:*Object",
      "s3:ListBucket"
    ]

    resources = [
      aws_s3_bucket.mlflow_bucket.arn,
      "${aws_s3_bucket.mlflow_bucket.arn}/*"
    ]
  }
}
resource "aws_iam_policy" "mlflow_server_policy" {
  name        = "mlflow-server-policy"
  description = "Allows mlflow access to S3"
  policy      = data.aws_iam_policy_document.mlflow_server_policy.json
}
// Create a random password to be used for the mlflow webserver
resource "random_password" "mlflow_password" {
  length  = 32
  special = false
}
resource "aws_ssm_parameter" "mlflow_password" {
  name        = "/mlflow/password"
  description = "Password for mlflow"
  type        = "SecureString"
  value       = random_password.mlflow_password.result
  overwrite   = true
}
