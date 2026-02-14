# Google Cloud Provider Configuration
provider "google" {
  project = "project-896a761b-267c-4d48-ba1"  
  region  = "us-central1"
}

# Creating a Cloud Storage bucket with lifecycle policy
resource "google_storage_bucket" "lifecycle_bucket" {
  name          = "my-lifecycle-bucket-100898"  # UniqueIdentifier
  location      = "US"
  force_destroy = true  # Allows Terraform to delete the bucket even if it contains objects

  uniform_bucket_level_access = true

  
  # Lifecycle rule to delete objects older than 1 day
  lifecycle_rule {
    condition {
      age = 1  # Delete files after 1 day
    }
    action {
      type = "Delete"
    }
  }
  
  # Adding labels for organization
  labels = {
    environment = "lab"
    managed_by  = "terraform"
  }
}

# Display
output "bucket_name" {
  value       = google_storage_bucket.lifecycle_bucket.name
  description = "The name of the storage bucket"
}

output "bucket_url" {
  value       = google_storage_bucket.lifecycle_bucket.url
  description = "The URL of the storage bucket"
}