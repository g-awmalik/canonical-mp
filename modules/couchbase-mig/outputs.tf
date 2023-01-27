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

output "mig_self_link" {
  description = "Self-link for the managed instance group"
  value       = module.mig.self_link
}

# output "mig_details" {
#   description = "Details for the google_compute_region_instance_group_manager of the instance group."
#   value       = module.mig.instance_group_manager
# }
