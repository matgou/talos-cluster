
output "control_plane_endpoint" {
  value = "https://${google_compute_global_address.controlplane.address}:6443"
}
output "kube_endpoint" {
  value = "https://${google_compute_global_address.controlplane.address}:6443"
}
output "kube_certificate" {
  value = data.talos_cluster_kubeconfig.this.client_configuration.client_certificate
}
output "kube_key" {
  value = data.talos_cluster_kubeconfig.this.client_configuration.client_key
}
output "kube_ca_certificate" {
  value = data.talos_cluster_kubeconfig.this.client_configuration.ca_certificate
}
data "talos_cluster_kubeconfig" "this" {
  depends_on = [
    talos_machine_bootstrap.this
  ]
  client_configuration = talos_machine_secrets.this.client_configuration
  node                 = google_compute_instance_from_template.bootstrap[keys(local.bootstrap_controlplane)[0]].network_interface[0].access_config[0].nat_ip
}

output "kubeconfig" {
  value     = data.talos_cluster_kubeconfig.this.kubeconfig_raw
  sensitive = true
}
