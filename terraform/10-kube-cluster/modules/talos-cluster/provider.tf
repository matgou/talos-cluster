terraform {
  required_providers {
    talos = {
      source  = "siderolabs/talos"
      version = "0.3.2"
    }
    google = {
      source  = "hashicorp/google"
      version = "5.22.0"
    }
  }
}

provider "google" {
  project = var.project
}
