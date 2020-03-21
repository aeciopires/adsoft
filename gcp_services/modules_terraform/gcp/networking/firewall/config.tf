provider "google" {
  credentials = file(var.service_account)
  project     = var.project_id
}

terraform {
  backend "gcs" {}
}

data "google_container_cluster" "testing_project1" {
  count    = length(var.testing_project1_cluster_name)
  name     = element(var.testing_project1_cluster_name, count.index)
  location = element(var.testing_project1_cluster_location, count.index)
}
