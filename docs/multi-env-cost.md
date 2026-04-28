# Multi-Environment Cost

The project tracks cost across three environments using separate tfvars files:

| Environment | File | Instance type | Expected relative cost |
| --- | --- | --- | --- |
| dev | `infra/envs/dev.tfvars` | `t3.micro` | Lowest |
| staging | `infra/envs/staging.tfvars` | `t3.small` | Higher than dev |
| prod | `infra/envs/prod.tfvars` | `t3.medium` | Highest |

Run:

```bash
./scripts/cost.sh
```

The script runs a Terraform plan and Infracost breakdown for each environment:

```bash
terraform plan -out tfplan-dev.binary -var-file=envs/dev.tfvars
terraform show -json tfplan-dev.binary > plan-dev.json
infracost breakdown --path . --terraform-var-file envs/dev.tfvars --format table
```

The same pattern runs for staging and prod.

## How Cost Scales

The VPC, subnet, and security group are effectively no-cost baseline resources. The EC2 instance type drives the monthly estimate. Moving from `t3.micro` to `t3.small` to `t3.medium` increases compute capacity and monthly cost.

This gives reviewers a simple cost signal: development stays small, staging approximates moderate load, and production is sized higher while remaining visible before merge.
