terraform {
  required_version = ">= 1.5"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 6.0"
    }
  }

  backend "gcs" {
    bucket = "sigil-terraform-state"
    prefix = "prod"
  }
}

provider "google" {
  project = var.gcp_project_id
  region  = var.region
}

module "network" {
  source       = "../../modules/network"
  project_name = "sigil"
  region       = var.region
}

module "database" {
  source       = "../../modules/database"
  project_name = "sigil"
  environment  = "prod"
  region       = var.region
  network_id   = module.network.network_id
  db_tier      = "db-custom-2-7680"
  disk_size_gb = 50
  db_password  = var.db_password
}

module "compute" {
  source       = "../../modules/compute"
  project_name = "sigil"
  environment  = "prod"
  zone         = var.zone
  subnet_id    = module.network.subnet_id
  machine_type = "e2-standard-2"
  db_host      = module.database.private_ip
  db_name      = module.database.database_name
  db_password  = var.db_password
}
