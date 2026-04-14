variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "zone" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "machine_type" {
  type    = string
  default = "e2-small"
}

variable "boot_disk_size_gb" {
  type    = number
  default = 20
}

variable "db_host" {
  type = string
}

variable "db_name" {
  type = string
}

variable "db_password" {
  type      = string
  sensitive = true
}
