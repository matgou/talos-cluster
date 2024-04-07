resource "google_storage_bucket" "image" {
  name                        = local.image_bucket
  location                    = var.region
  force_destroy               = true
  uniform_bucket_level_access = true
  versioning {
    enabled = false
  }
}
resource "null_resource" "image_download" {
  triggers = {
    on_version_change = "${var.image_src}"
  }

  provisioner "local-exec" {
    command = "curl -L -o image.raw ${var.image_src}"
  }

  provisioner "local-exec" {
    when    = destroy
    command = "rm image.raw"
  }
}

resource "google_storage_bucket_object" "image" {
  name       = local.image_name
  source     = "image.raw"
  bucket     = google_storage_bucket.image.name
  depends_on = [null_resource.image_download]
  lifecycle {
    ignore_changes = [detect_md5hash]
  }
}

resource "google_compute_image" "talos" {
  name = local.compute_image_name

  raw_disk {
    source = google_storage_bucket_object.image.media_link
  }
  guest_os_features {
    type = "VIRTIO_SCSI_MULTIQUEUE"
  }
}
