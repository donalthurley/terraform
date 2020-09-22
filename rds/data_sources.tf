data "terraform_remote_state" "vpc" {
  backend = "s3"

  config = {
    bucket = "packt-terraform-state-backup-${var.region}-dh"
    key = "test/vpc"
    region = var.region
  }
}
