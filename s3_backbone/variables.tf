variable "s3_bucket_name" {
  type        = string
  default     = "packt-terraform-section2-"
  description = "description"
}

variable "s3_tags" {
  type        = map

  default     = {
      created_by = "terraform"
      environment = "test"

  }
}

variable "s3_regions" {
    type = list
    default = ["eu-west-1", "eu-west-2"]
}
