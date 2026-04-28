# CI Guardrail

The GitHub Actions workflow in `.github/workflows/finops-ci.yaml` runs on pull requests and pushes to `main`.

## What CI Does

CI performs a plan-only check:

```bash
terraform init
terraform validate
terraform plan -out tfplan.binary -var-file=envs/dev.tfvars
terraform show -json tfplan.binary > plan.json
infracost diff --path . --compare-to https://github.com/<repo>?ref=main --format json --out-file infracost.json
```

No infrastructure is created or destroyed.

## Threshold Enforcement

The workflow reads `infracost.json`, sums each project's `diff.totalMonthlyCost` with `jq`, and compares the result to `COST_THRESHOLD_USD`.

The default threshold is:

```yaml
COST_THRESHOLD_USD: "50"
```

Pass case: a pull request increases monthly cost by `$50.00` or less.

Fail case: a pull request increases monthly cost by more than `$50.00`.

Cost decreases and no-cost changes pass.

## PR Comments

On pull requests, the workflow posts or updates an Infracost PR comment with `infracost comment github` when `GITHUB_TOKEN` has pull request write permission and `INFRACOST_API_KEY` is configured.

## Override Process

The safest override is to change `COST_THRESHOLD_USD` in the workflow through a reviewed pull request. For one-off exceptions, maintainers can rerun or merge according to branch protection policy after documenting the reason in the PR.

Avoid bypassing the check silently. The goal is not to block all spending, but to make cost changes visible and intentional.

## Required Secret

Add this repository secret before enabling the workflow:

```text
INFRACOST_API_KEY
```

Generate the key from Infracost, then store it in GitHub repository settings.
