resource "google_compute_instance" "serverpod" {
  name         = "${var.project_name}-server-${var.environment}"
  machine_type = var.machine_type
  zone         = var.zone

  tags = ["http-server", "serverpod"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-12"
      size  = var.boot_disk_size_gb
    }
  }

  network_interface {
    subnetwork = var.subnet_id

    access_config {
      // Ephemeral public IP
    }
  }

  metadata_startup_script = templatefile("${path.module}/startup.sh.tpl", {
    db_host     = var.db_host
    db_name     = var.db_name
    db_password = var.db_password
  })

  service_account {
    scopes = ["cloud-platform"]
  }
}
