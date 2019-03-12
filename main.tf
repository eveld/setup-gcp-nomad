provider "google" {
  project     = "${var.project}"
  region      = "${var.region}"
}

data "google_project" "project" {}