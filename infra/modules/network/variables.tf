variable "project_name" {
  type = string
}

variable "region" {
  type = string
}

variable "subnet_cidr" {
  type    = string
  default = "10.0.1.0/24"
}

variable "serverpod_allowed_cidrs" {
  type    = list(string)
  default = ["0.0.0.0/0"]
}
