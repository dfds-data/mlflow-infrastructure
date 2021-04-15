output "s3_bucket_uri" {
  value       = "s3://${aws_s3_bucket.mlflow_bucket.bucket}"
  description = "URI for the S3 bucket for artifact store"
}
output "s3_bucket_name" {
  value       = aws_s3_bucket.mlflow_bucket.bucket
  description = "Name of the S3 bucket for artifact store"
}

output "role_arn" {
  value       = aws_iam_role.mlflow_server_role.arn
  description = "The role to be assumed by the mlflow pods"
}
output "password" {
  value       = aws_ssm_parameter.mlflow_password.value
  description = "The randomly generated password for the mlflow tracking api"
  sensitive = true
}
