terraform {
  backend "gcs" {
    bucket = "your-bucket-id"
    prefix = "comfyui"
  }
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 7.1.1"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}
