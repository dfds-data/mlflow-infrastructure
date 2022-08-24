// Declare input variables
variable "kubernetes_account_number" {
  type        = string
  description = "The account number of the kubernetes cluster that has to assume a role in your capability"
}

variable "kubernetes_namespace" {
  type = string
  description = "The namespace of the kubernetes capability"
}

variable "service_account" {
  type = string
  default = "mlflow"
}