resource "talos_machine_secrets" "this" {}

data "talos_machine_configuration" "controlplane" {
  cluster_name     = var.cluster_name
  machine_type     = "controlplane"
  cluster_endpoint = "https://${google_compute_global_address.controlplane.address}:6443"
  machine_secrets  = talos_machine_secrets.this.machine_secrets
}

data "talos_machine_configuration" "worker" {
  cluster_name     = var.cluster_name
  machine_type     = "worker"
  cluster_endpoint = "https://${google_compute_global_address.controlplane.address}:6443"
  machine_secrets  = talos_machine_secrets.this.machine_secrets
}

data "talos_client_configuration" "this" {
  for_each             = { for k, v in local.controlplane : k => v if v.type == "compute" }
  cluster_name         = var.cluster_name
  client_configuration = talos_machine_secrets.this.client_configuration
  nodes                = [google_compute_instance_from_template.bootstrap[each.key].network_interface[0].access_config[0].nat_ip]
}


resource "talos_machine_bootstrap" "this" {
  for_each             = { for k, v in local.controlplane : k => v if v.type == "compute" }
  node                 = google_compute_instance_from_template.bootstrap[each.key].network_interface[0].access_config[0].nat_ip
  client_configuration = talos_machine_secrets.this.client_configuration
}

