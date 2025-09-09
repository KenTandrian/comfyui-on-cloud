output "load_balancer_ip" {
  value = google_compute_global_address.comfyui_static_ip.address
}
