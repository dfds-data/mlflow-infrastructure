variable "skip_final_snapshot" {
  description = "If true, no snapshot is created when database is deleted"
  default     = false
  type        = bool
}
