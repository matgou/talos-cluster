module "compute-image" {
  source       = "./modules/talos-image"
  project      = var.project
  cluster_name = "mg-k8s"
  region       = var.region
}

output "image_self_link" {
  value = module.compute-image.self_link
}
