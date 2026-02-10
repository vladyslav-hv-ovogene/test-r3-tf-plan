provider "google" {
  project = "project-28c66f1b-3d14-4963-88c"
  region  = "us-central1"
}

terraform {
  backend "gcs" {
    bucket = "victim-tf-state"
    prefix = "prod"
  }
}

resource "google_storage_bucket" "prod_bucket" {
  name     = "victim-prod-data"
  location = "US"
}
