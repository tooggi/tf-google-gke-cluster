output "config_host" {
  value = "https://${google_container_cluster.this.endpoint}"
}

output "config_ca" {
  value = base64decode(
    google_container_cluster.this.master_auth[0].cluster_ca_certificate
  )
}

output "config_client_certificate" {
  value = base64decode(
    google_container_cluster.this.master_auth[0].client_certificate
  )
}

output "config_client_key" {
  value = base64decode(
    google_container_cluster.this.master_auth[0].client_key
  )
  sensitive = true
}

output "name" {
  value = google_container_cluster.this.name
}
