provider "google" {
  project = var.project
}

resource "google_compute_network" "vpc_network" {
  name                    = "my-custom-mode-network"
  auto_create_subnetworks = false
  mtu                     = 1460
}

resource "google_compute_subnetwork" "default" {
  name          = "my-custom-subnet"
  ip_cidr_range = "10.0.1.0/24"
  region        = "us-central1"
  network       = google_compute_network.vpc_network.id
}

resource "google_compute_instance" "default" {
  name         = "test15"
  machine_type = "f1-micro"
  zone         = var.gcp_zone
  tags         = ["ssh"]

  boot_disk {
    initialize_params {
      #image = "debian-cloud/debian-11"
      image = "projects/flowers-342123/global/images/image-1"
    }
  }

  metadata_startup_script = "sudo apt-get update; sudo apt-get install -yq build-essential python3-pip rsync; pip install flask"

  network_interface {
    subnetwork = google_compute_subnetwork.default.id

    access_config {
    }
  }
}
