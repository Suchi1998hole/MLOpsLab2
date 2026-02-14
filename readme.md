# Terraform Cloud Storage Lifecycle Lab

## Project Overview
This lab demonstrates the fundamentals of Infrastructure as Code (IaC) using Terraform to manage Google Cloud Platform (GCP) resources. The project focuses on creating a Cloud Storage bucket with automated lifecycle management policies that delete objects after a specified age.

## What I Built
- **Cloud Storage Bucket**: Created a GCP storage bucket using Terraform
- **Lifecycle Policy**: Implemented automated deletion of objects older than 1 day
- **Uniform Bucket-Level Access**: Enabled IAM-based access control for security
- **Infrastructure as Code**: Managed all resources through declarative Terraform configuration

## Technologies Used
- **Terraform**: v1.14.5
- **Google Cloud Platform (GCP)**: Cloud Storage service
- **Google Cloud Provider**: v5.0+
- **Authentication**: Application Default Credentials (ADC)

## Prerequisites
- GCP account with billing enabled
- Terraform installed
- Google Cloud CLI (gcloud) installed
- Active GCP project

---

## Commands Used (macOS)

### 1. Initial Setup - Install Tools

```bash
# Install Terraform (if not already installed)
brew tap hashicorp/tap
brew install hashicorp/tap/terraform

# Verify Terraform installation
terraform --version

# Install Google Cloud CLI (if not already installed)
brew install --cask google-cloud-sdk
```

### 2. Authentication Setup

```bash
# Authenticate with your Google account
gcloud auth application-default login

# Set your GCP project
gcloud config set project project-896a761b-267c-4d48-ba1

# Verify authentication
gcloud auth list

# Enable required APIs
gcloud services enable storage-api.googleapis.com
```

### 3. Project Setup

```bash
# Create project directory
mkdir terraform-lifecycle-lab
cd terraform-lifecycle-lab

# Create main.tf file (see configuration below)
touch main.tf
```

### 4. Terraform Workflow

```bash
# Initialize Terraform (downloads provider plugins)
terraform init

# Format the configuration file
terraform fmt

# Validate the configuration
terraform validate

# Preview changes before applying
terraform plan

# Apply the configuration (create resources)
terraform apply
# Type 'yes' when prompted

# View the current state
terraform show

# List managed resources
terraform state list
```

### 5. Testing the Bucket

```bash
# Create a test file
echo "This is a test file for my Terraform lab" > test.txt

# Upload file to the bucket
gsutil cp test.txt gs://my-lifecycle-bucket-100898/

# List files in the bucket
gsutil ls gs://my-lifecycle-bucket-100898/

# View file details
gsutil ls -l gs://my-lifecycle-bucket-100898/
```

### 6. Modifying the Infrastructure

```bash
# After editing main.tf to change lifecycle age from 1 to 7 days:
terraform plan
terraform apply
```

### 7. Cleanup (Destroy Resources)

```bash
# Destroy all Terraform-managed resources
terraform destroy
# Type 'yes' when prompted

# Verify deletion in GCP Console
```

---

## Terraform Configuration

The main configuration file (`main.tf`) contains:

```hcl
terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
}

provider "google" {
  project = "project-896a761b-267c-4d48-ba1"
  region  = "us-central1"
}

resource "google_storage_bucket" "lifecycle_bucket" {
  name                        = "my-lifecycle-bucket-100898"
  location                    = "US"
  force_destroy               = true
  uniform_bucket_level_access = true

  lifecycle_rule {
    condition {
      age = 1  # Delete files after 1 day
    }
    action {
      type = "Delete"
    }
  }

  labels = {
    environment = "lab"
    managed_by  = "terraform"
  }
}

output "bucket_name" {
  value       = google_storage_bucket.lifecycle_bucket.name
  description = "The name of the storage bucket"
}

output "bucket_url" {
  value       = google_storage_bucket.lifecycle_bucket.url
  description = "The URL of the storage bucket"
}
```

---

## Project Structure

```
terraform-lifecycle-lab/
├── main.tf                    # Main Terraform configuration
├── terraform.tfstate          # Terraform state file (auto-generated)
├── terraform.tfstate.backup   # State backup (auto-generated)
├── .terraform.lock.hcl        # Provider version lock (auto-generated)
├── .terraform/                # Provider plugins directory (auto-generated)
└── test.txt                   # Test file for upload
```

---

## Key Learnings

### 1. Infrastructure as Code (IaC)
- Defined cloud infrastructure using declarative code
- Version-controlled infrastructure configurations
- Repeatable and consistent deployments

### 2. Terraform Workflow
- **Init**: Initialize working directory and download providers
- **Plan**: Preview infrastructure changes before applying
- **Apply**: Create or update infrastructure
- **Destroy**: Remove all managed resources

### 3. Cloud Storage Lifecycle Management
- Automated object deletion based on age
- Cost optimization through automatic cleanup
- Policies take up to 24 hours to take effect

### 4. GCP Authentication
- Used Application Default Credentials (ADC)
- No need for service account JSON keys
- Simplified authentication workflow

### 5. Terraform State Management
- State file tracks real-world resource status
- Critical for infrastructure management
- Never manually edit state files

---

## Common Issues and Solutions

### Issue 1: "Unsupported block type" error
**Solution**: Use `uniform_bucket_level_access = true` instead of a nested block

### Issue 2: "Request violates constraint 'constraints/storage.uniformBucketLevelAccess'"
**Solution**: Add `uniform_bucket_level_access = true` to the bucket resource

### Issue 3: Bucket name already exists
**Solution**: Change bucket name to something globally unique (bucket names must be unique across all of GCP)

### Issue 4: API not enabled
**Solution**: Run `gcloud services enable storage-api.googleapis.com`

---

## Verification Steps

1. **Check GCP Console**:
   - Navigate to Cloud Storage > Buckets
   - Verify bucket exists with name `my-lifecycle-bucket-100898`
   - Click bucket name → Lifecycle tab
   - Confirm rule: "Delete object after 1+ days"

2. **Check Terraform State**:
   ```bash
   terraform show
   terraform state list
   ```

3. **Check Bucket Contents**:
   ```bash
   gsutil ls gs://my-lifecycle-bucket-100898/
   ```

---

## Conclusion

This lab successfully demonstrated the power of Infrastructure as Code using Terraform to manage Google Cloud Platform resources. We accomplished the following:

**Automated Infrastructure Deployment**: Created a fully configured Cloud Storage bucket with a single `terraform apply` command, eliminating manual console configuration.

**Lifecycle Management**: Implemented cost-optimization through automated object deletion policies, reducing storage costs by automatically removing old files.

**Security Best Practices**: Enabled uniform bucket-level access to enforce IAM-based security controls across all objects.

**Reproducibility**: Documented infrastructure in code, making it easy to replicate the same setup across multiple environments or projects.

**Version Control Ready**: All infrastructure configuration is in a text file that can be committed to Git, enabling team collaboration and change tracking.

### Real-World Applications
- **Log Management**: Automatically delete application logs after 30-90 days
- **Backup Retention**: Move backups to cheaper storage classes before deletion
- **Cost Optimization**: Reduce storage costs by cleaning up temporary or expired data
- **Compliance**: Enforce data retention policies automatically

### Key Takeaway
Terraform transforms infrastructure management from manual, error-prone console clicking into automated, testable, and version-controlled code. This approach scales from small projects to enterprise-level infrastructure with thousands of resources.

## Resources

- [Terraform Documentation](https://developer.hashicorp.com/terraform/docs)
- [Google Cloud Storage Documentation](https://cloud.google.com/storage/docs)
- [Terraform Google Provider](https://registry.terraform.io/providers/hashicorp/google/latest/docs)
- [Object Lifecycle Management](https://cloud.google.com/storage/docs/lifecycle)

