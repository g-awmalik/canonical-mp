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

variable "project_id" {
  description = "The ID of the project in which to provision resources."
  type        = string
}

variable "name" {
  description = "The name of the VM instance for the deployment."
  type        = string
}

variable "zone" {
  description = "The zone for the solution to be deployed."
  type        = string
  default     = "us-west1-a"
}

variable "source_image" {
  description = "The image name for the disk for the VM instance."
  type        = string
}

variable "source_image_project" {
  description = "The project name where the solution image is stored."
  type        = string
  default     = "click-to-deploy-images"
}

variable "machine_type" {
  description = "The machine type to create, e.g. e2-small"
  type        = string
  default     = "n2-standard-4"
}

variable "boot_disk_size" {
  description = "The boot disk size for the VM instance in GBs"
  type        = string
  default     = "10"
}

variable "ip_source_ranges" {
  description = "A map of source IP ranges for accessing the VM instance over HTTP and/or HTTPS with the port no. as the key and the range as the value."
  type        = list(string)
  default     = []
}

variable "network" {
  description = "The name or self_link of the network to attach this interface to. Use network attribute for Legacy or Auto subnetted networks and subnetwork for custom subnetted networks."
  type        = string
  default     = ""
}

variable "subnetwork" {
  description = "The name of the subnetwork to attach this interface to. The subnetwork must exist in the same region this instance will be created in. Either network or subnetwork must be provided."
  type        = string
  default     = ""
}

variable "service_account_email" {
  type        = string
  description = "The email for service account to attach to the instance"
}

variable "instance_count" {
  description = "The target number of running instances for this managed instance group"
  type        = number
  default     = 1
}

variable "cb_version" {
  description = "The version of Couchbase database to install on the VM"
  type        = string
  default     = "3.0.3"
}

variable "cb_admin_username" {
  description = "The username to the admin console for Couchbase database"
  type        = string
}

variable "cb_admin_password" {
  description = "The password to the admin console for Couchbase database"
  type        = string
}

variable "cb_bucket_name" {
  description = "The GCS bucket name for the Couchbase database"
  type        = string
  default     = null
}

variable "cb_connection_string" {
  description = "The connection string for connecting to the Couchbase database"
  type        = string
  default     = null
}
