
# Template d'instance
resource "google_compute_instance_template" "nodepool" {
  for_each     = local.ig_nodepool
  name         = "${var.cluster_name}-template-${each.key}"
  machine_type = each.value.machine_type

  disk {
    source_image = each.value.source_image
    auto_delete  = true
    boot         = true
    disk_size_gb = 20
  }
  tags = [
    "${var.cluster_name}-worker",
    "allow-health-check",
  ]

  scheduling {
    automatic_restart           = each.value.provisioning_model == "SPOT" ? false : true
    provisioning_model          = each.value.provisioning_model
    preemptible                 = each.value.provisioning_model == "SPOT" ? true : false
    instance_termination_action = "STOP"
    on_host_maintenance         = "TERMINATE"
  }

  network_interface {
    network    = data.google_compute_network.vpc.self_link
    subnetwork = data.google_compute_subnetwork.subnet.self_link
    access_config {}
  }
  metadata = {
    user-data = data.talos_machine_configuration.worker.machine_configuration
  }

  service_account {
    email  = google_service_account.controlplane.email
    scopes = ["cloud-platform"]
  }
  lifecycle {
    create_before_destroy = true
  }
}

# Google compute instance group manager
resource "google_compute_instance_group_manager" "nodepools" {
  for_each           = local.ig_nodepool
  name               = "${var.cluster_name}-${each.key}-nodepool-igm"
  base_instance_name = "${var.cluster_name}-${each.key}-nodepool"
  zone               = each.value.zone

  version {
    instance_template = google_compute_instance_template.nodepool[each.key].self_link_unique
  }
  target_size = each.value.size
}
