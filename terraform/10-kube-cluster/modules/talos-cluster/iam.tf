
resource "google_project_iam_member" "compute" {
  project = data.google_project.project.project_id
  role    = "roles/compute.instanceAdmin"
  member  = "serviceAccount:${data.google_project.project.number}@cloudservices.gserviceaccount.com"
}
