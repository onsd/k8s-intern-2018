#####################################################################
# GKE Cluster
#####################################################################
provider "google" {
  credentials = "${file("${var.credentials}")}"
  project     = "${var.project}"
  region      = "${var.region}"
}

resource "google_container_cluster" "ca-k8s" {
  count              = "${var.cluster_count}"
  name               = "${format("${var.cluster_name_prefix}%02d", count.index + 1)}"
  zone               = "asia-northeast1-a"
  initial_node_count = 3
  min_master_version = "${var.gke_version}"
  node_version       = "${var.gke_version}"

  addons_config {
    network_policy_config {
      disabled = false
    }
    kubernetes_dashboard {
      disabled = true
    }
  }

  network_policy {
    enabled = true
    provider = "CALICO"
  }

  master_auth {
    username = "${var.username}"
    password = "${var.password}"
  }

  node_config {
    machine_type = "${var.machine_type}"
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

resource "google_container_cluster" "ca-k8s-tw" {
  count              = "${var.cluster_count_tw}"
  name               = "${format("${var.cluster_name_prefix}%02d", count.index + 31)}"
  zone               = "asia-east1-a"
  initial_node_count = 3
  min_master_version = "${var.gke_version}"
  node_version       = "${var.gke_version}"
  network            = "default2"

  addons_config {
    network_policy_config {
      disabled = false
    }
    kubernetes_dashboard {
      disabled = true
    }
  }

  network_policy {
    enabled = true
    provider = "CALICO"
  }

  master_auth {
    username = "${var.username}"
    password = "${var.password}"
  }

  node_config {
    machine_type = "${var.machine_type}"
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
