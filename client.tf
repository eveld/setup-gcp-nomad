resource "google_compute_region_instance_group_manager" "client" {
  name = "client-group-manager"

  base_instance_name        = "nomad-client"
  region                    = var.project_region
  distribution_policy_zones = var.instance_zones

  version {
    instance_template = google_compute_instance_template.client.id
  }

  target_pools = [google_compute_target_pool.client.id]
  target_size  = var.client_instance_count

  named_port {
    name = "http"
    port = 4646
  }

  auto_healing_policies {
    health_check      = google_compute_http_health_check.nomad.self_link
    initial_delay_sec = 300
  }
}

resource "google_compute_instance_template" "client" {
  name_prefix  = "nomad-client-"
  machine_type = var.client_instance_type

  tags = [var.client_instance_tag, "allow-health-check"]

  disk {
    source_image = var.client_instance_image
    auto_delete  = true
    disk_size_gb = 20
    boot         = true
  }

  metadata_startup_script = data.template_file.client_startup_script.rendered

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

resource "google_compute_target_pool" "client" {
  name = "client-pool"

  health_checks = [
    google_compute_http_health_check.nomad.name,
  ]
}

// The startup script of the Nomad clients.
data "template_file" "client_startup_script" {
  template = file("${path.module}/files/client.sh")
  vars = {
    SERVER_INSTANCE_TAG = var.server_instance_tag
  }
}