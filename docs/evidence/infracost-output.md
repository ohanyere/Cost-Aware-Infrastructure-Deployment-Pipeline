# Evidence: Infracost Output

Sample table for the default dev environment:

```text
Project: cost-aware-infra

Name                                           Quantity  Unit   Monthly Cost
aws_instance.app
  Instance usage, Linux/UNIX, on-demand          730     hours  ~$7.59
  root_block_device, gp3 storage                   8     GB     ~$0.64

PROJECT TOTAL                                                   ~$8.23
```

Evidence command:

```bash
cd infra
terraform plan -out tfplan-dev.binary -var-file=envs/dev.tfvars
terraform show -json tfplan-dev.binary > plan-dev.json
infracost breakdown --path . --terraform-var-file envs/dev.tfvars --format table
```
