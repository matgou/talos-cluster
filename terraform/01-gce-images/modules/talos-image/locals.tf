locals {
  image_name         = basename(var.image_src)
  image_bucket       = "${var.cluster_name}-${random_id.bucket.hex}"
  compute_image_name = "${var.cluster_name}-${random_id.bucket.hex}"
}
