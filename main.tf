provider "google" {
  version = "3.5.0"
 #access_token = "ya29.a0AVvZVsoXXSGQlW4WCd9nrzMRBn9AYVTgZAMpdJw5uVRMaDrVa0Meg1QLzDyiyH1vUDyckiYkAnoqm5zQ-QKNFzD2xsUFtbk3Irr55OihNJ1wQ71MhRUURk_1841GiaDRRA-bBsUuB9t8qQJiH1qRuz8KrkZ17aIMFz5u9rIaCgYKAeUSAQASFQGbdwaI2-z93EcqAChSImoeEWjYpw0174"
  project = "roses-344817"
  region  = "us-central1"
  zone    = "us-central1-c"
}

resource "google_compute_network" "vpc_network" {
  name                    = "my-custom-mode-network"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "default" {
  name          = "my-custom-subnet"
  ip_cidr_range = "10.0.1.0/24"
  region        = "us-central1"
  network       = google_compute_network.vpc_network.id
}

# Create a single Compute Engine instance
resource "google_compute_instance" "default" {
  name         = "flask-vm"
  machine_type = "f1-micro"
  zone         = "us-central1-c"
  tags         = ["ssh"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  # Install Flask
  metadata_startup_script = "sudo apt-get update; sudo apt-get install -yq build-essential python3-pip rsync; pip install flask"

  network_interface {
    subnetwork = google_compute_subnetwork.default.id

    access_config {
      # Include this section to give the VM an external IP address
    }
  }
}
