resource "google_sql_database_instance" "postgres" {
  name             = "${var.project_name}-db-${var.environment}"
  database_version = "POSTGRES_16"
  region           = var.region

  settings {
    tier              = var.db_tier
    availability_type = var.environment == "prod" ? "REGIONAL" : "ZONAL"
    disk_size         = var.disk_size_gb

    ip_configuration {
      ipv4_enabled    = false
      private_network = var.network_id
    }

    backup_configuration {
      enabled                        = var.environment == "prod"
      point_in_time_recovery_enabled = var.environment == "prod"
    }
  }

  deletion_protection = var.environment == "prod"
}

resource "google_sql_database" "sigil" {
  name     = "sigil"
  instance = google_sql_database_instance.postgres.name
}

resource "google_sql_user" "sigil" {
  name     = "sigil"
  instance = google_sql_database_instance.postgres.name
  password = var.db_password
}
