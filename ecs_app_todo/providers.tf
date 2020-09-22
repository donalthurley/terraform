provider "aws" {
    region = var.region

    version = "3.5.0"
}

provider "template" {
    version = "2.1"
}

terraform {
    required_version = ">= 0.13"
    
    backend "s3" {
        bucket = "packt-terraform-state-backup-eu-west-1-dh"

        key = "test/ecs_app_todo"

        region = "eu-west-1"
    
        encrypt = "true"
    }
}