terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "7.3.0"
    }
  }
}

provider "google" {
  project = var.project_id
}

resource "google_project_iam_member" "composer_agent_service_account" {
  project = var.project_id
  role = "roles/composer.serviceAgent"
  member = "serviceAccount:service-${var.project_number}@gcp-sa-composer.iam.gserviceaccount.com"
}

resource "google_composer_environment" "test" {
  name   = "example-composer-env"
  region = "us-central1"
  config {
    software_config {
      image_version = "composer-3-airflow-2"
    }
  }
}

variable "project_id" {
  description = "Project id"
  default     = "banded-scion-461009-a0"
}
variable "project_number" {
  description = "Project Number"
  default = "143720609546"
