variable "project" {
  type        = string
  description = "Id of Google cloud project to use"
}
variable "image_src" {
  default = "https://github.com/siderolabs/talos/releases/download/v1.6.7/gcp-amd64.raw.tar.gz"
}
variable "cluster_name" {
  type        = string
  description = "Name of cluster "
  validation {
    condition     = can(regex("^[-a-z0-9]{4,16}$", var.cluster_name))
    error_message = "The cluster_name value must match regex ^[-a-z0-9]{4,16}$"
  }
}
variable "image_bucket" {
  default = "talos-image-mgoulin-8a845"
}
variable "image_name" {
  default = "talos-image-mgoulin-8a845"
}

variable "region" {}
