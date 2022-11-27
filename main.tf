/**
 * Copyright 2021 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
provider "google" {
  project = var.project_id
}

locals {
  network_interfaces_map = { for o in var.network_interfaces : o.network => {
    network     = o.network,
    subnetwork  = o.subnetwork,
    external_ip = o.external_ip,
    }
  }
}

resource "google_compute_instance" "default" {
  name         = var.name
  machine_type = var.machine_type
  zone         = var.zone

  metadata = {
    enable-oslogin           = "TRUE"
    google-logging-enable    = var.enable_logging == true ? "1" : "0"
    google-monitoring-enable = var.enable_monitoring == true ? "1" : "0"
    wordpress-admin-email    = var.wp_admin_email
    wordpress-enable-https   = var.wp_https_enabled == true ? "True" : "False"
    installphpmyadmin        = var.wp_install_phpmyadmin == true ? "True" : "False"
    wordpress-mysql-password = random_password.mysql.result
    mysql-root-password      = random_password.root.result
    wordpress-admin-password = random_password.admin.result
  }

  boot_disk {
    initialize_params {
      size  = var.boot_disk_size
      type  = var.boot_disk_type
      image = "projects/${var.source_image_project}/global/images/${var.source_image}"
    }
  }

  dynamic "network_interface" {
    for_each = local.network_interfaces_map
    content {
      network    = network_interface.key
      subnetwork = network_interface.value.subnetwork

      dynamic "access_config" {
        for_each = compact([network_interface.value.external_ip == "None" ? null : 1])
        content {
          nat_ip = network_interface.value.external_ip == "Ephemeral" ? null : network_interface.value.external_ip
        }
      }
    }
  }

  tags = length(var.ip_source_ranges) > 0 ? ["${var.name}-deployment"] : []
  service_account {
    scopes = [
      "https://www.googleapis.com/auth/cloud.useraccounts.readonly",
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring.write",
      "https://www.googleapis.com/auth/cloudruntimeconfig",
    ]
  }
}

resource "google_compute_firewall" "http" {
  for_each = var.ip_source_ranges
  project  = var.project_id
  name     = "${var.name}-tcp-${each.key}"
  network  = var.network_interfaces[0].network

  allow {
    protocol = "tcp"
    ports    = [each.key]
  }

  source_ranges = [each.value]
  target_tags   = ["${var.name}-deployment"]
}

resource "random_password" "mysql" {
  length  = 8
  special = false
}

resource "random_password" "root" {
  length  = 14
  special = false
}

resource "random_password" "admin" {
  length           = 8
  special          = true
  override_special = "-"
}
