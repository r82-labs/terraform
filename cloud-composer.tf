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
