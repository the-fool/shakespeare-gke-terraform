resource "google_container_cluster" "shakespeare" {
  name                     = "shakespeare"
  location                 = "us-central1"
  initial_node_count       = 1
  remove_default_node_pool = true

  master_auth {
    username = "${var.username}"
    password = "${var.password}"
  }

  node_config {
    oauth_scopes = [
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/service.management.readonly",
      "https://www.googleapis.com/auth/servicecontrol",
      "https://www.googleapis.com/auth/trace.append",
      "https://www.googleapis.com/auth/compute",
    ]
  }
}


resource "google_container_node_pool" "primary-pool" {
  name     = "shakespeare-primary"
  cluster  = "${google_container_cluster.shakespeare.name}"
  location = "us-central1"
  initial_node_count = 1
  autoscaling {
    min_node_count = 1
    max_node_count = 3
  }

  node_config {
    machine_type = "n1-standard-1"
  }

  management {
    auto_repair  = true
    auto_upgrade = true
  }
}

#####################################################################
# Output for K8S
#####################################################################
output "client_certificate" {
  value     = "${google_container_cluster.shakespeare.master_auth.0.client_certificate}"
  sensitive = true
}

output "client_key" {
  value     = "${google_container_cluster.shakespeare.master_auth.0.client_key}"
  sensitive = true
}

output "cluster_ca_certificate" {
  value     = "${google_container_cluster.shakespeare.master_auth.0.cluster_ca_certificate}"
  sensitive = true
}

output "host" {
  value     = "${google_container_cluster.shakespeare.endpoint}"
  sensitive = true
}