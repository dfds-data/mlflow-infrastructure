// Set the cloud provider to AWS
provider "aws" {
  region = "eu-central-1"
}
locals {
  name = "mlflow"
  tags = {
    Name        = "mlflow"
    Environment = "prod"
  }
}
resource "aws_default_vpc" "default" {
  tags = local.tags
}
resource "aws_default_subnet" "default_az1" {
  availability_zone = "eu-central-1a"

  tags = {
    Name = "Default subnet for eu-central-1a"
  }
}
resource "aws_default_subnet" "default_az2" {
  availability_zone = "eu-central-1b"

  tags = {
    Name = "Default subnet for eu-central-1b"
  }
}
module "security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 3"

  name        = "${local.name}-database-security-group"
  description = "${local.name} backend security group"
  vpc_id      = aws_default_vpc.default.id

  # ingress
  ingress_with_cidr_blocks = [
    {
      rule        = "postgresql-tcp"
      cidr_blocks = "0.0.0.0/0"
    },
  ]
  tags = local.tags
}
module "db" {
  source  = "terraform-aws-modules/rds/aws"
  version = "5.9.0"

  identifier = local.name

  create_db_option_group    = false
  create_db_parameter_group = true

  # All available versions: https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/CHAP_PostgreSQL.html#PostgreSQL.Concepts
  engine         = "postgres"
  engine_version = "14"
  family         = "postgres14" # DB parameter group
  instance_class = "db.t3.small"
  allocated_storage = 40

  # Upgrading engine versions
  allow_major_version_upgrade = true
  auto_minor_version_upgrade  = true

  # Apply changes during maintenance window
  apply_immediately = false

  # NOTE: Do NOT use 'user' as the value for 'username' as it throws:
  # "Error creating DB Instance: InvalidParameterValue: MasterUsername
  # user cannot be used as it is a reserved word used by the engine"
  username               = "superuser"
  create_random_password = true
  random_password_length = 32
  port                   = 5432
  publicly_accessible    = true

  vpc_security_group_ids = [module.security_group.security_group_id]

  maintenance_window = "Mon:00:00-Mon:03:00"
  backup_window      = "03:00-06:00"

  backup_retention_period = 10

  parameters = [
    {
      name  = "rds.force_ssl"
      value = 1
    },
    # Set timeout for idle connections to 24 hours in milliseconds
    # See https://postgresqlco.nf/doc/en/param/idle_session_timeout/
    {
      name = "idle_session_timeout"
      value = 86400000 
    }
  ]

  create_db_subnet_group = true
  subnet_ids             = [aws_default_subnet.default_az1.id, aws_default_subnet.default_az2.id]
  tags                   = local.tags

  storage_encrypted = false
}

resource "aws_ssm_parameter" "database_password" {
  name        = "/mlflow/db_credentials"
  description = "Password for mlflow"
  type        = "SecureString"
  value = jsonencode({
    "username" = module.db.db_instance_username
    "password" = module.db.db_instance_password
  })
  overwrite = true
}
