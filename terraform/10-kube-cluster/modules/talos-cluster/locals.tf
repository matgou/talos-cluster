
locals {
  controlplane = { for i, k in var.controlplane_pools : i => {
    machine_type       = k.machine_type
    provisioning_model = k.provisioning_model
    type               = k.type
    size               = k.size
    source_image       = k.source_image
    zone               = k.zone
    active             = k.active
  } }
  bootstrap_controlplane = { for k, v in local.controlplane : k => v if v.type == "compute" }
  ig_controlplane        = { for k, v in local.controlplane : k => v if v.type != "compute" }
  ig_nodepool            = { for k, v in var.worker_pools : k => v }
}
