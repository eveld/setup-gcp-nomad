resource "google_compute_firewall" "allow_health_check" {
  name    = "allow-health-check"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["4646"]
  }

  source_ranges = ["130.211.0.0/22", "35.191.0.0/16"]
  target_tags   = ["allow-health-check"]
}

resource "google_compute_firewall" "allow_whitelist" {
  name    = "nomad-allow-whitelist"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["4646"]
  }

  source_ranges = var.whitelist
  target_tags   = ["nomad-server"]
}

resource "google_compute_http_health_check" "nomad" {
  name               = "default"
  port               = 4646
  request_path       = "/v1/status/leader"
  check_interval_sec = 1
  timeout_sec        = 1
}

# resource "google_compute_backend_service" "server" {
#   name     = "nomad-server"
#   protocol = "HTTP"

#   health_checks = [google_compute_http_health_check.nomad.id]

#   backend {
#     group = google_compute_region_instance_group_manager.server.instance_group
#   }
# }

# resource "google_compute_url_map" "server_map" {
#   name            = "nomad-server-map"
#   default_service = google_compute_backend_service.server.id
# }

# resource "google_compute_global_address" "server_ip" {
#   name = "nomad-server-ip"
# }

# data "google_iam_policy" "admin" {
#   binding {
#     role = "roles/iap.httpsResourceAccessor"
#     members = [
#       "user:eveld@hashicorp.com",
#     ]
#   }
# }

# resource "google_iap_web_backend_service_iam_policy" "server_policy" {
#   web_backend_service = google_compute_backend_service.server.name
#   policy_data         = data.google_iam_policy.admin.policy_data
# }

# resource "google_compute_target_http_proxy" "server_proxy" {
#   name    = "nomad-server-proxy"
#   url_map = google_compute_url_map.server_map.self_link
# }

# resource "google_compute_global_forwarding_rule" "server_forward" {
#   name       = "nomad-server-forward"
#   target     = google_compute_target_http_proxy.server_proxy.self_link
#   ip_address = google_compute_global_address.server_ip.address
#   port_range = "80"
# }