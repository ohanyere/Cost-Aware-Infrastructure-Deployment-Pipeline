# Cost Workflow

This project estimates infrastructure cost before deployment. Terraform creates a plan only; Infracost reads that plan and calculates an estimated monthly cost for supported resources.

## Local Workflow

Run the helper script:

```bash
./scripts/cost.sh
```

Or run the commands directly:

```bash
cd infra
terraform init
terraform validate
terraform plan -out tfplan.binary -var-file=envs/dev.tfvars
terraform show -json tfplan.binary > plan.json
cd ..
infracost breakdown --path infra --terraform-var-file envs/dev.tfvars --format table
```

The Terraform plan contains the proposed resources. The `plan.json` file is the machine-readable plan that Infracost uses for pricing.

## Cost-Relevant Variables

The main cost lever is:

```hcl
instance_type = "t3.micro"
```

Change `instance_type` in an environment file under `infra/envs/`, then rerun the cost workflow. For example, changing from `t3.micro` to `t3.large` should increase the estimated monthly compute cost.

## Reading Infracost Output

Infracost shows resources, usage assumptions, monthly quantity, unit price, and monthly cost. The total is an estimate of recurring monthly infrastructure cost if the plan were applied.

Monthly cost does not mean a current AWS bill. It is a projection based on the Terraform plan, Infracost pricing data, and default usage assumptions.

## Cost Diffs

To compare against a saved baseline:

```bash
infracost breakdown --path infra --terraform-var-file envs/dev.tfvars --format json --out-file baseline.json
infracost diff --path infra --terraform-var-file envs/dev.tfvars --compare-to baseline.json --format table
```

In CI, Infracost compares the pull request plan to the target branch when the GitHub integration is configured. For local workflows, keep a `baseline.json` from the previous accepted state and compare changes against it.

## Limitations

These estimates are not bills. They may exclude unsupported resources, taxes, discounts, private pricing, credits, free tier behavior, and usage-based charges that are not represented in Terraform.

This repository intentionally avoids `terraform apply` and `terraform destroy`. The workflow is for cost visibility and merge protection only.
