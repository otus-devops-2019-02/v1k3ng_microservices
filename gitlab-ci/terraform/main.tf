terraform {
  required_version = ">=0.11,<0.12"
}

provider "google" {
  version = "2.0.0"
  project = "${var.project}"
  region  = "europe-west-1"
}

resource "google_compute_project_metadata" "default" {
  project = "${var.project}"

  metadata {
    ssh-keys = "appuser:${file(var.public_key_path)}"
  }
}

resource "google_compute_instance" "gitlab-ci" {
  name         = "gitlab-ci"
  machine_type = "n1-standard-1"
  zone         = "europe-west1-b"
  tags         = ["gitlab-ci"]

  # определение загрузочного диска
  boot_disk {
    initialize_params {
      image = "${var.disk_image}"
      size = "60"
    }
  }

  # определение сетевого интерфейса
  network_interface {
    # сеть, к которой присоединить данный интерфейс
    network = "default"

    # использовать IP reddit-app-ip
    access_config = {}
  }

  metadata {
    # путь до публичного ключа
    ssh-keys = "appuser:${file(var.public_key_path)}"
  }

  provisioner "remote-exec" {
    inline = ["sudo mkdir -p /srv/gitlab/config /srv/gitlab/data /srv/gitlab/logs"]
    connection {
      type        = "ssh"
      user        = "appuser"
      private_key = "${file(var.private_key_path)}"
    }
  }

  provisioner "local-exec" {
    command = "ansible-playbook -u appuser -i '${self.network_interface.0.access_config.0.nat_ip},' -e \"host_ip='${self.network_interface.0.access_config.0.nat_ip}'\" --private-key ${var.private_key_path} ../ansible/gitlab-install.yml" 
  }

  provisioner "remote-exec" {
    inline = ["cd /srv/gitlab/ && sudo docker-compose up -d"]
    connection {
      type        = "ssh"
      user        = "appuser"
      private_key = "${file(var.private_key_path)}"
    }
  }
}

resource "google_compute_instance" "gitlab-main-runner" {
  name         = "gitlab-main-runner"
  machine_type = "g1-small"
  zone         = "europe-west1-b"
  tags         = ["gitlab-main-runner"]

  # определение загрузочного диска
  boot_disk {
    initialize_params {
      image = "${var.disk_image}"
    }
  }

  # определение сетевого интерфейса
  network_interface {
    # сеть, к которой присоединить данный интерфейс
    network = "default"

    # использовать IP reddit-app-ip
    access_config = {}
  }

  metadata {
    # путь до публичного ключа
    ssh-keys = "appuser:${file(var.public_key_path)}"
  }

  provisioner "remote-exec" {
    inline = [
        "uptime"
      ]
    connection {
      type        = "ssh"
      user        = "appuser"
      private_key = "${file(var.private_key_path)}"
    }
  }

  provisioner "local-exec" {
    command = "ansible-playbook -u appuser -i '${self.network_interface.0.access_config.0.nat_ip},' -e \"host-ip='${self.network_interface.0.access_config.0.nat_ip}'\" -e \"gitlab-ci-ip='${google_compute_instance.gitlab-ci.network_interface.0.access_config.0.nat_ip}'\" --private-key ${var.private_key_path} ../ansible/gitlab-runner-install.yml" 
  }

  // provisioner "remote-exec" {
  //   inline = [
  //     ""
  //     ]
  //   connection {
  //     type        = "ssh"
  //     user        = "appuser"
  //     private_key = "${file(var.private_key_path)}"
  //   }
  // }
}

// resource "google_compute_firewall" "firewall_gitlab-ci" {
//   name = "allow-gitlab-ci-container"

//   # Название сети, в которой действует правило
//   network = "default"

//   # Какой доступ разрешить
//   allow {
//     protocol = "tcp"
//     ports    = ["9292"]
//   }

//   # Каким адресам разрешаем доступ
//   source_ranges = ["0.0.0.0/0"]

//   # Правило применимо для инстансов с перечисленными тэгами
//   target_tags = ["reddit-app-docker"]
// }

resource "google_compute_firewall" "firewall_http" {
  name        = "default-allow-http"
  // description = "Allow HTTP from 178.236.210.50"
  description = "Allow HTTP from anyone"

  # Название сети, в которой действует правило
  network = "default"

  # Какой доступ разрешить
  allow {
    protocol = "tcp"
    ports    = ["80","443"]
  }

  # Каким адресам разрешаем доступ
  // source_ranges = ["178.236.210.50/32", "51.75.92.240/32"]
  source_ranges = ["0.0.0.0/0"]
  target_tags = ["gitlab-ci"]
}

// resource "google_compute_firewall" "firewall_ssh" {
//   name        = "default-allow-ssh"
//   description = "Allow SSH from 178.236.210.50"

//   # Название сети, в которой действует правило
//   network = "default"

//   # Какой доступ разрешить
//   allow {
//     protocol = "tcp"
//     ports    = ["22"]
//   }

//   # Каким адресам разрешаем доступ
//   source_ranges = ["178.236.210.50/32"]
//   target_tags = ["gitlab-ci"]
// }


