
# allow all access from health check ranges
resource "google_compute_firewall" "fw_hc" {
  name          = "l4-ilb-fw-allow-hc"
  direction     = "INGRESS"
  network       = data.google_compute_network.vpc.name
  source_ranges = ["130.211.0.0/22", "35.191.0.0/16", "35.235.240.0/20"]
  allow {
    protocol = "tcp"
  }
  target_tags = ["allow-health-check"]
}


resource "google_compute_firewall" "rules" {
  project            = var.project
  name               = "${var.cluster_name}-egress-rule"
  network            = data.google_compute_network.vpc.name
  description        = "Creates firewall rule for egress Talos controlplane"
  direction          = "EGRESS"
  destination_ranges = ["0.0.0.0/0"]
  source_ranges      = ["0.0.0.0/0"]
  allow {
    protocol = "tcp"
  }
  allow {
    protocol = "udp"
  }
  allow {
    protocol = "icmp"
  }

  #log_config {
  #  metadata = "EXCLUDE_ALL_METADATA"
  #}
}
resource "google_compute_firewall" "ingress" {
  project            = var.project
  name               = "${var.cluster_name}-ingress-rule"
  network            = data.google_compute_network.vpc.name
  description        = "Creates firewall rule for egress Talos controlplane"
  direction          = "INGRESS"
  destination_ranges = ["0.0.0.0/0"]
  source_ranges      = ["0.0.0.0/0"]
  allow {
    protocol = "tcp"
  }
  allow {
    protocol = "udp"
  }
  allow {
    protocol = "icmp"
  }

  #log_config {
  #  metadata = "EXCLUDE_ALL_METADATA"
  #}
}
