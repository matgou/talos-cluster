variable "project" {
  type        = string
  description = "Id of Google cloud project to use"
}
variable "vpc" {}
variable "subnet" {}
variable "region" {}
variable "zone" {}
variable "cluster_name" {}
variable "controlplane_pools" {}
variable "worker_pools" {}
