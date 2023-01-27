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

module "couchbase_mig" {
  source                = "../../modules/couchbase-mig"
  project_id            = var.project_id
  name                  = "couchbase-simple-tf"
  zone                  = "us-west1-a"
  source_image          = "couchbase-sync-gateway-hourly-pricing-v20220817"
  source_image_project  = "couchbase-public"
  machine_type          = "e2-medium"
  boot_disk_size        = "100"
  network               = "default"
  subnetwork            = "default"
  cb_version            = "3.0.3"
  cb_admin_username     = "cb-admin"
  cb_admin_password     = "cb-password"
  cb_connection_string  = "cb-test-conn-string"
  instance_count        = 2
  service_account_email = "sa-couchbase-id-01@gscrp-sbx-01.iam.gserviceaccount.com"
  ip_source_ranges = [
    "0.0.0.0/0",
  ]
}
