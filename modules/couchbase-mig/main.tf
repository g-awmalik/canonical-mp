/**
 * Copyright 2023 Google LLC
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

locals {
  service_account = {
    email = var.service_account_email
    scopes : [
      "https://www.googleapis.com/auth/cloud-platform",
      "https://www.googleapis.com/auth/cloud.useraccounts.readonly",
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring.write",
      "https://www.googleapis.com/auth/cloudruntimeconfig"
    ]
  }

  metadata = {
    "couchbase-gateway-version"    = var.cb_version
    "couchbase-server-bucket-name" = var.cb_bucket_name
  }

  secrets = {
    "cb_admin_username"    = var.cb_admin_username
    "cb_admin_password"    = var.cb_admin_password
    "cb_connection_string" = var.cb_connection_string
  }

  health_probe_ips = [
    "130.211.0.0/22",
    "35.191.0.0/16",
  ]
}

module "instance_template" {
  source               = "terraform-google-modules/vm/google//modules/instance_template"
  version              = "~> 8.0"
  project_id           = var.project_id
  region               = substr(var.zone, 0, length(var.zone) - 2)
  network              = var.network
  subnetwork           = var.subnetwork
  subnetwork_project   = var.project_id
  machine_type         = var.machine_type
  disk_size_gb         = var.boot_disk_size
  service_account      = local.service_account
  source_image         = var.source_image
  source_image_project = var.source_image_project
  metadata             = local.metadata
  tags                 = ["${var.name}-deployment"]
  access_config = [{
    nat_ip       = null
    network_tier = "PREMIUM"
  }]
}

module "mig" {
  source            = "terraform-google-modules/vm/google//modules/mig"
  version           = "~> 8.0"
  project_id        = var.project_id
  region            = substr(var.zone, 0, length(var.zone) - 2)
  target_size       = var.instance_count
  hostname          = var.name
  instance_template = module.instance_template.self_link
  health_check = {
    type                = "http"
    initial_delay_sec   = 300
    check_interval_sec  = 30
    healthy_threshold   = 1
    timeout_sec         = 10
    unhealthy_threshold = 5
    response            = ""
    proxy_header        = "NONE"
    port                = 4984
    request             = ""
    request_path        = "/"
    host                = ""
    enable_logging      = false
  }
}

# create secrets for sensitive data
resource "google_secret_manager_secret" "cb_secrets" {
  for_each  = local.secrets
  project   = var.project_id
  secret_id = each.key
  replication {
    automatic = true
  }
}

resource "google_secret_manager_secret_version" "cb_secrets_data" {
  for_each    = local.secrets
  secret      = google_secret_manager_secret.cb_secrets[each.key].id
  secret_data = each.value
}

# firewall rules to allow access to the admin and user web console
resource "google_compute_firewall" "http" {
  count   = length(var.ip_source_ranges) != 0 ? 1 : 0
  project = var.project_id
  name    = "${var.name}-allow-tcp"
  network = var.network

  allow {
    protocol = "tcp"
    ports    = [4984, 4985, 4986]
  }

  source_ranges = var.ip_source_ranges
  target_tags   = ["${var.name}-deployment"]
}

# firewall rules to allow health check probes
resource "google_compute_firewall" "http_health_probe" {
  project = var.project_id
  name    = "allow-health-check"
  network = var.network

  allow {
    protocol = "tcp"
    ports    = [4984]
  }

  source_ranges = local.health_probe_ips
}
