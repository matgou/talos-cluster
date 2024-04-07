# Google compute instance group manager
resource "google_compute_instance_group_manager" "controlplane" {
  for_each           = local.ig_controlplane
  name               = "${var.cluster_name}-${each.key}-igm"
  base_instance_name = "${var.cluster_name}-${each.key}-controlplane"
  zone               = each.value.zone

  version {
    instance_template = google_compute_instance_template.controlplane[each.key].self_link_unique
  }
  target_size = each.value.size
  named_port {
    name = "tcp6443"
    port = 6443
  }
}
