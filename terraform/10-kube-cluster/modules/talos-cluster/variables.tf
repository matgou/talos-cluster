variable "project" {
  type        = string
  description = "Id of Google cloud project to use"
}
variable "vpc" {}
variable "subnet" {}
variable "region" {}

variable "cluster_name" {
  type        = string
  description = "Name of cluster "
  validation {
    condition     = can(regex("^[-a-z0-9]{4,16}$", var.cluster_name))
    error_message = "The cluster_name value must match regex ^[-a-z0-9]{4,16}$"
  }
}

variable "endpoint_exposure" {
  default     = "EXTERNAL"
  description = "Is endpoint public or private"
  validation {
    condition     = can(regex("^(EXTERNAL|INTERNAL)$", var.endpoint_exposure))
    error_message = "The endpoint_exposure value must match regex ^(EXTERNAL|INTERNAL)$"
  }
}

variable "controlplane_pools" {
  type = map(object({
    machine_type       = string
    provisioning_model = string
    type               = string
    size               = optional(number)
    source_image       = string
    zone               = string
    active             = optional(bool, false)
  }))
  description = "Description of controlplane nodes (must at least contains a bootstrap compute spot instance)"
}

variable "worker_pools" {
  type = map(object({
    machine_type       = string
    provisioning_model = string
    size               = optional(number)
    source_image       = string
    zone               = string
    active             = optional(bool, false)
  }))
  description = "Description of controlplane nodes (must at least contains a bootstrap compute spot instance)"
}
