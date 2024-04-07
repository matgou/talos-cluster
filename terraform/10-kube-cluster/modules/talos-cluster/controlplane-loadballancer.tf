# Tcp proxy
resource "google_compute_target_tcp_proxy" "default" {
  name            = "${var.cluster_name}-proxy"
  backend_service = google_compute_backend_service.talos.id
}
# forwarding rule
resource "google_compute_global_forwarding_rule" "default" {
  name                  = "${var.cluster_name}-proxy-xlb-forwarding-rule"
  ip_protocol           = "TCP"
  load_balancing_scheme = "EXTERNAL"
  port_range            = "6443"
  target                = google_compute_target_tcp_proxy.default.id
  ip_address            = google_compute_global_address.controlplane.address
}

resource "google_compute_backend_service" "talos" {
  name        = "${var.cluster_name}-controlplane-bs"
  protocol    = "TCP"
  timeout_sec = 10
  port_name   = "tcp6443"

  health_checks         = [google_compute_health_check.talos.id]
  load_balancing_scheme = var.endpoint_exposure

  dynamic "backend" {
    for_each = { for k, v in local.bootstrap_controlplane : v.zone => { zone = v.zone } if v.active }
    content {
      group = google_compute_instance_group.controlplane[backend.key].id
    }
  }
  dynamic "backend" {
    for_each = { for k, v in local.ig_controlplane : k => v if v.active }
    content {
      group = google_compute_instance_group_manager.controlplane[backend.key].instance_group
    }
  }
  depends_on = [google_compute_instance_group.controlplane, google_compute_instance_group_manager.controlplane]
}

resource "google_compute_health_check" "talos" {
  name               = "${var.cluster_name}-hc"
  timeout_sec        = 1
  check_interval_sec = 30

  tcp_health_check {
    port = "6443"
  }
}
