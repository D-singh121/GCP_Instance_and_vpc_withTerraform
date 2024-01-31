resource "google_compute_instance" "my_instance" {
  count                     = 2
  name                      = "terraform-instance"
  machine_type              = "e2-micro"
  zone                      = var.zone
  allow_stopping_for_update = true


  boot_disk {
    initialize_params {
      image = "ubuntu-2204-jammy-v20240126"
      # image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    network    = google_compute_network.terraform-vpc-network.self_link   # attaching the vpc network
    subnetwork = google_compute_subnetwork.terraform-vpc-subnet.self_link # attaching subnet to the network_interface
    access_config {
      //Ephemeral pubilc ip
    }
  }
}

# VPC creation
resource "google_compute_network" "terraform-vpc-network" {
  name                    = "terraform-vpc-network"
  auto_create_subnetworks = false
}

# Subnet creation
resource "google_compute_subnetwork" "terraform-vpc-subnet" {
  name          = "terraform-vpc-subnetwork"
  ip_cidr_range = "10.2.0.0/16"
  region        = var.region
  network       = google_compute_network.terraform-vpc-network.id

}
