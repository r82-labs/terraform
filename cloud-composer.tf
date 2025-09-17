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

resource "google_cloud_run_v2_service" "default" {
  name     = "cloudrun-service"
  location = "us-central1"
  deletion_protection = false
  ingress = "INGRESS_TRAFFIC_ALL"

  scaling {
    max_instance_count = 100
  }

  template {
    containers {
      image = "us-docker.pkg.dev/cloudrun/container/hello"
    }
  }
}

resource "google_cloud_run_service_iam_member" "invoker" {
  service  = google_cloud_run_v2_service.default.name      # The name of the Cloud Run service to grant access to
  location = google_cloud_run_v2_service.default.location  # The region where the Cloud Run service is deployed
  role     = "roles/run.invoker"                        # The IAM role being granted (allows invoking the service)
  member   = "allUsers"                                 # The identity receiving the role (all users, public access)
}

variable "project_id" {
  description = "Project id"
  default     = "banded-scion-461009-a0"
}
