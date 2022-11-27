# Simple Example

This example illustrates how to use the `canonical-mp` module to provision a simple Wordpress instance on the default VPC exposed via an ephemeral public IP.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| project\_id | The ID of the project in which to provision resources. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| admin\_password | Password for the admin user |
| admin\_url | Administration URL for the Wordpress |
| admin\_user | Admin username for Wordpress |
| instance\_machine\_type | Machine type for the wordpress compute instance |
| instance\_self\_link | Self-link for the Wordpress compute instance |
| instance\_zone | Zone for the wordpress compute instance |
| mysql\_password | Password for the MySql user |
| mysql\_user | MySql username for Wordpress |
| root\_password | Password for the root user |
| root\_user | Root username for Wordpress |
| site\_address | Site address for the Worpress |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

To provision this example, run the following from within this directory:
- `terraform init` to get the plugins
- `terraform plan` to see the infrastructure plan
- `terraform apply` to apply the infrastructure build
- `terraform destroy` to destroy the built infrastructure
