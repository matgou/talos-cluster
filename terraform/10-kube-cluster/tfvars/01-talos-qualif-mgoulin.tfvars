project = "sandbox-mgoulin"

vpc    = "pa-vpc-qualif-q0180-sandbox-1234"
subnet = "pa-subnet-qualif-q0180-sandbox-1235"
region = "europe-west1"
zone   = "europe-west1-b"

cluster_name = "mg-k8s"

controlplane_pools = {
  "bootstrap" = {
    machine_type       = "e2-micro"
    provisioning_model = "STANDARD"
    type               = "compute"
    zone               = "europe-west1-b"
    source_image       = "https://www.googleapis.com/compute/v1/projects/sandbox-mgoulin/global/images/mg-k8s-6284642c9ea5692c"
    active             = true
  }
  "group" = {
    machine_type       = "e2-medium"
    provisioning_model = "SPOT"
    type               = "instance-group"
    size               = 2
    zone               = "europe-west1-b"
    source_image       = "https://www.googleapis.com/compute/v1/projects/sandbox-mgoulin/global/images/mg-k8s-6284642c9ea5692c"
    active             = true
  }
}

worker_pools = {
  "np2" = {
    machine_type       = "e2-medium"
    provisioning_model = "SPOT"
    zone               = "europe-west1-b"
    source_image       = "https://www.googleapis.com/compute/v1/projects/sandbox-mgoulin/global/images/mg-k8s-6284642c9ea5692c"
    size               = 2
  }
}
