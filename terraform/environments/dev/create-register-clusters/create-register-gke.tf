provider "google" {
  version = "~> 3.8"
  credentials = file("/home/rajesh_debian/first-service-account.json")
  project     = var.project_id
  region      = var.region
}

provider "google-beta" {
  version = "~> 3.8"
  credentials = file("/home/rajesh_debian/first-service-account.json")
  project = var.project_id
  region  = var.region
}

resource "google_container_cluster" "primary" {
  name     = "my-gke-cluster"
  location = "us-central1"
  remove_default_node_pool = true
  initial_node_count = 1

  # workload_identity_config {
  #     identity_namespace = "${var.project_id}.svc.id.goog"
  #   }

  master_auth {
    username = ""
    password = ""

    client_certificate_config {
      issue_client_certificate = false
    }
  }
}

resource "google_container_node_pool" "node_pool" {
  name       = "my-node-pool"
  location   = "us-central1"
  cluster    = google_container_cluster.primary.name
  node_count = 1

  node_config {
    preemptible  = false
    machine_type = "e2-medium"

    # workload_metadata_config {
    #     node_metadata = "GKE_METADATA_SERVER"
    #   }

    metadata = {
      disable-legacy-endpoints = "true"
    }

    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/devstorage.read_only", // allows to pull images from gcr
      "https://www.googleapis.com/auth/service.management.readonly",
      "https://www.googleapis.com/auth/servicecontrol",
      "https://www.googleapis.com/auth/trace.append",
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
}

resource "null_resource" "register-gke" {

  provisioner "local-exec" {
    interpreter = ["bash", "-exc"]
    command     = <<EOT
    echo "${google_container_node_pool.node_pool.name}..."
    gcloud container hub memberships register "${google_container_cluster.primary.name}" \
    --project="${var.project_id}" \
    --gke-uri="https://container.googleapis.com/${google_container_cluster.primary.id}" \
    --service-account-key-file="/home/rajesh_debian/first-service-account.json"
    EOT
  }

  triggers = {
    node_pool = google_container_node_pool.node_pool.name
  }

}

