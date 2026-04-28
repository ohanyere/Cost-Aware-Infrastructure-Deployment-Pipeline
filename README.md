# FinOps Cost-Aware Deployment Pipeline

This project demonstrates a CI-driven cost guardrail for Terraform infrastructure. It estimates monthly infrastructure cost before deployment, comments on pull requests, and fails expensive changes before merge.

## Cost Guardrail

Pull requests run Terraform in plan-only mode and then run Infracost:

```bash
terraform plan -out tfplan.binary -var-file=envs/dev.tfvars
terraform show -json tfplan.binary > plan.json
infracost diff --path . --compare-to https://github.com/<repo>?ref=main --format json --out-file infracost.json
```

The workflow comments on the PR with `infracost comment github` and blocks the merge when the monthly increase is greater than `$50`.

## Cost Comparison

Environment sizing is controlled through tfvars:

| Environment | Instance type |
| --- | --- |
| dev | `t3.micro` |
| staging | `t3.small` |
| prod | `t3.medium` |

Run:

```bash
./scripts/cost.sh
```

## Live Validation

Live validation is manual and short-lived:

```bash
RUN_LIVE=1 ./scripts/apply-and-destroy.sh
```

The script applies the stack, waits 60 seconds, and destroys it. It is never called by CI.

## Sample Fail Case

Change:

```diff
- instance_type = "t3.micro"
+ instance_type = "t3.large"
```

Expected result: CI fails if the monthly cost increase exceeds the `$50` threshold.

## Limitations

Infracost estimates are not cloud bills. Real billing can include discounts, credits, taxes, free tier behavior, private pricing, regional pricing changes, and usage-based charges that are not fully represented in Terraform.

The live validation workflow requires real AWS credentials and may incur small costs.
