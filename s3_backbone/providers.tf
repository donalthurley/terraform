provider "aws" {
    region = "eu-west-1"
}

terraform {
    required_version = ">= 0.13"
    
    backend "s3" {
        bucket = "packt-terraform-state-backup-eu-west-1-dh"

        key = "test/backbone"

        region = "eu-west-1"

        encrypt = "true"
    }
}