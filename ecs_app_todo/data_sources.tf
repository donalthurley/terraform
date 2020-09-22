data "terraform_remote_state" "vpc" {
  backend = "s3"

  config = {
    bucket = "packt-terraform-state-backup-${var.region}-dh"
    key = "test/vpc"
    region = var.region
  }
}

data "terraform_remote_state" "rds" {
  backend = "s3"

  config = {
    bucket = "packt-terraform-state-backup-${var.region}-dh"
    key = "test/rds"
    region = var.region
  }
}

data "terraform_remote_state" "ecs_cluster" {
  backend = "s3"

  config = {
    bucket = "packt-terraform-state-backup-${var.region}-dh"
    key = "test/ecs_cluster"
    region = var.region
  }
}
