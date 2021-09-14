output "db_username" {
  description = "Username for the database master"
  value       = module.db.db_instance_username
  sensitive   = true
}
output "db_password" {
  description = "Password for the database master"
  value       = module.db.db_instance_password
  sensitive   = true
}
output "db_host" {
  description = "Address for the database"
  value       = module.db.db_instance_address
}
