data "google_compute_instance" "comfyui_vm" {
  name = var.vm_name
  zone = var.zone
}

resource "google_compute_instance_group" "comfyui_instance_group" {
  name      = "comfyui-instance-group"
  zone      = var.zone
  instances = [data.google_compute_instance.comfyui_vm.self_link]

  named_port {
    name = "http"
    port = 8188
  }
}

resource "google_compute_health_check" "http_health_check" {
  name                = "http-health-check"
  check_interval_sec  = 5
  timeout_sec         = 5
  healthy_threshold   = 2
  unhealthy_threshold = 2

  http_health_check {
    port         = 8188
    request_path = "/"
  }
}

resource "google_compute_backend_service" "comfyui_backend_service" {
  name                  = "comfyui-backend-service"
  protocol              = "HTTP"
  port_name             = "http"
  load_balancing_scheme = "EXTERNAL"
  health_checks         = [google_compute_health_check.http_health_check.self_link]

  backend {
    group = google_compute_instance_group.comfyui_instance_group.self_link
  }
}

resource "google_compute_managed_ssl_certificate" "comfyui_ssl_certificate" {
  name    = "comfyui-ssl-certificate"
  managed {
    domains = [var.domain_name]
  }
}

resource "google_compute_url_map" "comfyui_url_map" {
  name            = "comfyui-url-map"
  default_service = google_compute_backend_service.comfyui_backend_service.self_link
}

resource "google_compute_target_https_proxy" "comfyui_https_proxy" {
  name             = "comfyui-https-proxy"
  url_map          = google_compute_url_map.comfyui_url_map.self_link
  ssl_certificates = [google_compute_managed_ssl_certificate.comfyui_ssl_certificate.self_link]
}

resource "google_compute_global_address" "comfyui_static_ip" {
  name = "comfyui-static-ip"
}

resource "google_compute_global_forwarding_rule" "comfyui_forwarding_rule" {
  name                  = "comfyui-forwarding-rule"
  target                = google_compute_target_https_proxy.comfyui_https_proxy.self_link
  ip_address            = google_compute_global_address.comfyui_static_ip.address
  port_range            = "443"
  load_balancing_scheme = "EXTERNAL"
}

resource "google_compute_firewall" "allow_lb_comfyui" {
  name    = "allow-lb-comfyui"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["8188"]
  }

  source_ranges = ["130.211.0.0/22", "35.191.0.0/16"]
  target_tags   = ["comfyui-vm"]
}
