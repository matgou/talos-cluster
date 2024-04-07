module "cluster" {
  source             = "./modules/talos-cluster"
  project            = var.project
  vpc                = var.vpc
  subnet             = var.subnet
  region             = var.region
  cluster_name       = "mg-k8s"
  controlplane_pools = var.controlplane_pools
  worker_pools       = var.worker_pools
}

#output "kubeconfig" {
#  value     = module.cluster.kubeconfig
#  sensitive = true
#}

#output "control_plane_ip" {
#  value = module.cluster.control_plane_endpoint
#}
