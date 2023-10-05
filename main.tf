terraform {
    required_providers {
       google = {
        source = "hashicorp/google"
        version = "~> 4.10"
      }
    }
}

terraform {
    backend "gcs" {
        bucket ="bu123djkfjdkfjkdjfj"
    }
}
// Activation des apis nécessaire : 
resource "google_project_service" "ressource_manager" {
    service = "cloudresourcemanager.googleapis.com"
}
resource "google_project_service" "artifact" {
    service = "artifactregistry.googleapis.com"
    depends_on = [ google_project_service.ressource_manager ]
}
resource "google_project_service" "cloudresourcemanager" {
  service = "cloudresourcemanager.googleapis.com"
}

resource "google_project_service" "serviceusage" {
  service = "serviceusage.googleapis.com"
}

resource "google_project_service" "sqladmin" {
  service = "sqladmin.googleapis.com"
}

resource "google_project_service" "cloudbuild" {
  service = "cloudbuild.googleapis.com"
}
 # Pour le artifact_registry
resource "google_artifact_registry_repository" "my-repo" {
  location      = "us-west1"
  repository_id = "website-tools"
  description   = "Repo Docker"
  format        = "DOCKER"

  depends_on = [ google_project_service.artifact ]
}
#Définition google sql user
resource "google_sql_user" "wordpress" {
   name     = "wordpress"
   instance = "main-instance"
   password = "ilovedevops"
}

#Pour la bd
resource "google_sql_database" "wordpress" {
  name     = "wordpress"
  instance = "main-instance"
}
