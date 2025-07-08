# Configure the Google Cloud provider
provider "google" {
  # The GCP project to use
  project = var.GOOGLE_PROJECT
  # The GCP region to deploy resources in
  region = var.GOOGLE_REGION
  zone   = var.GOOGLE_ZONE
}

# Create the GKE (Google Kubernetes Engine) cluster
resource "google_container_cluster" "this" {
  # Name of the cluster
  name = var.GKE_CLUSTER_NAME
  # Location (region) for the cluster
  location = var.GOOGLE_ZONE

  # Set initial node count (required, but will remove default pool)
  initial_node_count = 1
  # Remove default node pool to use custom node pools instead
  remove_default_node_pool = true
  deletion_protection      = false

  # Workload Identity configuration for GKE
  workload_identity_config {
    workload_pool = "${var.GOOGLE_PROJECT}.svc.id.goog"
  }

  # Node configuration for metadata
  node_config {
    workload_metadata_config {
      mode = "GKE_METADATA"
    }
  }
}

# Create a custom node pool for the GKE cluster
resource "google_container_node_pool" "this" {
  # Name of the node pool
  name = var.GKE_POOL_NAME
  # GCP project to use (derived from the cluster)
  project = google_container_cluster.this.project
  # Attach node pool to the created cluster
  cluster = google_container_cluster.this.name
  # Location (region)
  location = google_container_cluster.this.location
  # Number of nodes in the pool
  node_count = var.GKE_NUM_NODES

  # Node configuration
  node_config {
    # Machine type for the nodes
    machine_type = var.GKE_MACHINE_TYPE
    spot         = var.GKE_SPOT
  }
}

