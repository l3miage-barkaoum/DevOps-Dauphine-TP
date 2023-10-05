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
resource "google_project_service" "cloud_run" {
  service = "run.googleapis.com"
}
 # Pour le artifact_registry
resource "google_artifact_registry_repository" "my-repo" {
  location      = "us-central1"
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
resource "google_cloud_run_service" "default" {
name     = "serveur-wordpress"
location = "us-central1"

template {
   spec {
      containers {
      image = "us-central1-docker.pkg.dev/solid-course-399708/website-tools/mon-image-wordpress"
      ports {
        container_port= 80
      }
      }
   }

   metadata {
      annotations = {
            "run.googleapis.com/cloudsql-instances" = "solid-course-399708:us-central1:main-instance"
      }
   }
}

traffic {
   percent         = 100
   latest_revision = true
}
}
data "google_iam_policy" "noauth" {
   binding {
      role = "roles/run.invoker"
      members = [
         "allUsers",
      ]
   }
}

resource "google_cloud_run_service_iam_policy" "noauth" {
   location    = google_cloud_run_service.default.location
   project     = google_cloud_run_service.default.project
   service     = google_cloud_run_service.default.name

   policy_data = data.google_iam_policy.noauth.policy_data
}