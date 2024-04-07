locals {
  is_internal = var.endpoint_exposure == "INTERNAL" ? true : false
}
data "google_compute_network" "vpc" {
  name = var.vpc
}
data "google_compute_subnetwork" "subnet" {
  name   = var.subnet
  region = var.region
}

data "google_project" "project" {
  project_id = var.project
}
