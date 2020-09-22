variable "environment" {
  type = string
  default = "test"
}

variable "region" {
  type = string
}

variable "app_name" {
  type = string
}

variable "app_image_repository" {
  type = string
}

variable "app_image_version" {
  type = string
}

variable "container_port" {
  type = string
}

variable "pgsslmode" {
  type = string
}
