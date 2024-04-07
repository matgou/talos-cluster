# Service account for controlplane instances
resource "google_service_account" "controlplane" {
  account_id   = "${var.cluster_name}-plane"
  display_name = "Talos ${var.cluster_name} controlplane Service Account"
}
resource "google_service_account_iam_member" "controlplane" {
  role               = "roles/iam.serviceAccountUser"
  service_account_id = google_service_account.controlplane.id
  member             = "serviceAccount:${data.google_project.project.number}@cloudservices.gserviceaccount.com"
}

# Ip address for loadballancer
resource "google_compute_global_address" "controlplane" {
  name         = "${var.cluster_name}-controlplane"
  address_type = var.endpoint_exposure
}

resource "google_compute_instance_group" "controlplane" {
  for_each = {
    for k, v in local.bootstrap_controlplane : v.zone => { zone = v.zone }
  }
  name        = "${var.cluster_name}-controlplane-${each.key}-ig"
  description = "ControlPlane instance group"

  instances = [for k, v in local.bootstrap_controlplane :
    google_compute_instance_from_template.bootstrap[k].self_link if v.zone == each.value.zone && v.active
  ]

  named_port {
    name = "tcp6443"
    port = "6443"
  }
  zone = each.value.zone
}


resource "google_compute_instance_from_template" "bootstrap" {
  for_each = local.bootstrap_controlplane
  name     = "${var.cluster_name}-controlplane-bootstrap-${random_id.ig[each.key].hex}"
  zone     = each.value.zone

  source_instance_template = google_compute_instance_template.controlplane[each.key].self_link_unique

  // Override fields from instance template
  can_ip_forward = false
}

# random uid
resource "random_id" "ig" {
  for_each    = local.controlplane
  byte_length = 8
}
# Template d'instance
resource "google_compute_instance_template" "controlplane" {
  for_each     = local.controlplane
  name         = "${var.cluster_name}-template-${each.key}-${random_id.ig[each.key].hex}"
  machine_type = each.value.machine_type

  disk {
    source_image = each.value.source_image
    auto_delete  = true
    boot         = true
    disk_size_gb = 20
  }
  tags = [
    "${var.cluster_name}-controlplane",
    "allow-health-check",
  ]

  scheduling {
    automatic_restart           = each.value.provisioning_model == "SPOT" ? false : true
    provisioning_model          = each.value.provisioning_model
    preemptible                 = each.value.provisioning_model == "SPOT" ? true : false
    instance_termination_action = each.value.provisioning_model == "SPOT" ? "STOP" : null
    on_host_maintenance         = each.value.provisioning_model == "SPOT" ? "TERMINATE" : null
  }

  network_interface {
    network    = data.google_compute_network.vpc.self_link
    subnetwork = data.google_compute_subnetwork.subnet.self_link
    access_config {}
  }
  metadata = {
    user-data = data.talos_machine_configuration.controlplane.machine_configuration
  }

  service_account {
    email  = google_service_account.controlplane.email
    scopes = ["cloud-platform"]
  }
  lifecycle {
    create_before_destroy = true
  }
}
