// Declare input variables
variable "kubernetes_account_number" {
  type        = string
  description = "The account number of the kubernetes capability. E.g. '123456789012'"
}

variable "kubernetes_namespace" {
  type = string
  description = "The namespace of the kubernetes capability. E.g. 'my-capability-jpoxj'."
}

variable "service_account" {
  type = string
  default = "mlflow"
  description = "The service account that assumes the mlflow-server-role Role. E.g. 'mlflow'."
}