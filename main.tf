terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
  required_version = ">= 1.5.0"
}

provider "google" {
  project = var.project_id
  region  = var.region
}

resource "google_cloud_run_service" "default" {
  name     = var.service_name
  location = var.region

  template {
    spec {
      containers {
        image = nginx:latest

        env {
          name  = "ENVIRONMENT"
          value = "dev"
        }

        ports {
          container_port = 80  # Ensure the container is listening on port 8080
        }

        resources {
          limits = {
            cpu    = "1"
            memory = "512Mi"
          }
          requests = {
            cpu    = "0.5"
            memory = "256Mi"
          }
        }
      }
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }

