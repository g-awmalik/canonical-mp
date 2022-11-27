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

output "instance_self_link" {
  description = "Self-link for the Wordpress compute instance"
  value       = module.canonical_mp.instance_self_link
}

output "instance_zone" {
  description = "Zone for the wordpress compute instance"
  value       = module.canonical_mp.instance_zone
}

output "instance_machine_type" {
  description = "Machine type for the wordpress compute instance"
  value       = module.canonical_mp.instance_machine_type
}

output "site_address" {
  description = "Site address for the Worpress"
  value       = module.canonical_mp.site_address
}

output "admin_url" {
  description = "Administration URL for the Wordpress"
  value       = module.canonical_mp.admin_url
}

output "mysql_user" {
  description = "MySql username for Wordpress"
  value       = module.canonical_mp.mysql_user
}

output "mysql_password" {
  description = "Password for the MySql user"
  value       = module.canonical_mp.mysql_password
  sensitive   = true
}

output "root_user" {
  description = "Root username for Wordpress"
  value       = module.canonical_mp.root_user
}

output "root_password" {
  description = "Password for the root user"
  value       = module.canonical_mp.root_password
  sensitive   = true
}

output "admin_user" {
  description = "Admin username for Wordpress"
  value       = module.canonical_mp.admin_user
}

output "admin_password" {
  description = "Password for the admin user"
  value       = module.canonical_mp.admin_password
  sensitive   = true
}
