resource "google_compute_region_instance_group_manager" "server" {
  name = "server-group-manager"

  base_instance_name        = "nomad-server"
  region                    = var.project_region
  distribution_policy_zones = var.instance_zones

  version {
    instance_template = google_compute_instance_template.server.id
  }

  target_pools = [google_compute_target_pool.server.id]
  target_size  = var.server_instance_count

  named_port {
    name = "http"
    port = 4646
  }

  auto_healing_policies {
    health_check      = google_compute_http_health_check.nomad.self_link
    initial_delay_sec = 300
  }
}

resource "google_compute_instance_template" "server" {
  name_prefix  = "nomad-server-"
  machine_type = var.server_instance_type

  tags = [var.server_instance_tag, "allow-health-check"]

  disk {
    source_image = var.server_instance_image
    auto_delete  = true
    disk_size_gb = 20
    boot         = true
  }

  metadata_startup_script = data.template_file.server_startup_script.rendered

  can_ip_forward = false
  network_interface {
    network = "default"

    access_config {}
  }

  lifecycle {
    create_before_destroy = true
  }

  service_account {
    scopes = ["userinfo-email", "compute-ro", "storage-ro"]
  }
}

resource "google_compute_target_pool" "server" {
  name = "server-pool"

  health_checks = [
    google_compute_http_health_check.nomad.name,
  ]
}

// The startup script of the Nomad servers.
data "template_file" "server_startup_script" {
  template = file("${path.module}/files/server.sh")
  vars = {
    SERVER_INSTANCE_COUNT = var.server_instance_count
    SERVER_INSTANCE_TAG   = var.server_instance_tag
  }
}