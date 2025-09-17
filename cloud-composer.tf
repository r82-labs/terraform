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
  member = "serviceAccount:full-admin@${var.project_id}.iam.gserviceaccount.com"
}

resource "google_composer_environment" "composer_env" {
  name = "example-composer-env"
  region = "us-central1"

  config {
    node_count = 3
    node_config {
      machine_type = "n1-standard-1"
    }
    software_config {
      image_version = "composer-3-airflow-2"
    }
    workloads_config {
      scheduler {
        cpu = 1.0
        memory_gb = 4.0
      }
      worker {
        cpu = 1.0
        memory_gb = 4.0
      }
      web_server {
        cpu = 1.0
        memory_gb = 4.0
      }
    }
  }

  depends_on = [google_project_iam_member.composer_agent_service_account]
}

variable "project_id" {
  description = "Project id"
  default     = "banded-scion-461009-a0"
}

variable "project_number" {
  description = "Project Number"
  default = "143720609546"
}
