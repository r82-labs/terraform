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
  role    = "roles/composer.serviceAgent"
  member  = "serviceAccount:service-${var.project_number}@gcp-sa-composer.iam.gserviceaccount.com"
}

resource "google_composer_environment" "composer_env" {
  name = "example-composer-env"
  region = "us-central1"

  config {
    software_config {
      image_version = "composer-3-airflow-2"
    }
    workloads_config {
      scheduler {
        cpu        = 0.5
        memory_gb  = 2
        storage_gb = 1
        count      = 1
      }
      triggerer {
        cpu        = 0.5
        memory_gb  = 1
        count      = 1
      }
      dag_processor {
        cpu        = 1
        memory_gb  = 2
        storage_gb = 1
        count      = 1
      }
      web_server {
        cpu        = 0.5
        memory_gb  = 2
        storage_gb = 1
      }
      worker {
        cpu = 0.5
        memory_gb  = 2
        storage_gb = 1
        min_count  = 1
        max_count  = 3
      }

    }
    environment_size = "ENVIRONMENT_SIZE_SMALL"

    node_config {
      service_account = google_service_account.test.name
    }
  }
  depends_on = [
    google_project_iam_member.composer_agent_service_account
  ]
}

resource "google_service_account" "test" {
  account_id   = "composer-env-account"
  display_name = "Test Service Account for Composer Environment"
}

resource "google_project_iam_member" "composer-worker" {
  project = var.project_id
  role    = "roles/composer.worker"
  member  = "serviceAccount:${google_service_account.test.email}"
}
variable "project_id" {
  description = "Project id"
  default     = "banded-scion-461009-a0"
}

variable "project_number" {
  description = "Project Number"
  default = "143720609546"
}
