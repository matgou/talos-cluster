#module "config" {
#  source              = "./modules/kube-config"
#  kube_endpoint       = module.cluster.kube_endpoint
#  kube_certificate    = module.cluster.kube_certificate
#  kube_key            = module.cluster.kube_key
#  kube_ca_certificate = module.cluster.kube_ca_certificate
#}
