# FinOps Cost-Aware Infrastructure Deployment Pipeline

This project estimates infrastructure cost before deployment, comments cost diffs on pull requests, and blocks expensive infrastructure changes before they are merged. It demonstrates how platform engineering teams can add FinOps guardrails directly into the delivery workflow without applying infrastructure from CI.

## Problem Statement

Infrastructure changes are often reviewed for correctness, security, and reliability, but not for cost impact. A small Terraform change, such as increasing an instance size or adding a managed service, can materially increase monthly cloud spend before finance, platform, or application teams notice.

This pipeline shifts cost visibility left. Developers see estimated monthly cost changes during pull request review, while CI enforces a budget threshold that prevents high-cost changes from merging without deliberate review.

## Key Features

- Terraform plan-only workflow for safe infrastructure review
- Infracost cost estimation from Terraform plan output
- Pull request cost comments for reviewer visibility
- CI threshold enforcement to block expensive changes
- Multi-environment cost comparison across `dev`, `staging`, and `prod`
- Resource tagging for cost allocation and ownership
- Controlled live validation gated by an explicit `RUN_LIVE` flag

## Architecture

```text
Developer -> Pull Request -> GitHub Actions -> Terraform Plan -> Infracost Diff -> Threshold Check -> Pass/Fail
```

The pipeline is intentionally designed as a review and guardrail workflow. GitHub Actions generates a Terraform plan, converts it to JSON, runs an Infracost diff against the main branch, comments the cost impact on the pull request, and fails the check when the projected monthly increase exceeds the configured threshold.

## Cost Guardrail

The core workflow is based on four steps:

```bash
terraform plan -out tfplan.binary -var-file=envs/dev.tfvars
terraform show -json tfplan.binary > plan.json
infracost diff --path . --compare-to https://github.com/ohanyere/Cost-Aware-Infrastructure-Deployment-Pipeline?ref=main --format json --out-file infracost.json
infracost comment github --path infracost.json --repo <owner>/<repo> --pull-request <pr-number> --github-token <token>
```

CI enforces a monthly cost increase threshold of `$50`. If the estimated increase is greater than the threshold, the pull request check fails and the change must be reviewed or revised before merge.

## Multi-Environment Cost Comparison

Environment-specific Terraform variable files model different infrastructure sizes for each stage:

| Environment | Instance type |
| --- | --- |
| dev | `t3.micro` |
| staging | `t3.small` |
| prod | `t3.medium` |

This makes cost differences visible before infrastructure is promoted across environments and helps teams understand the financial impact of environment sizing decisions.

## Example Fail Case

Changing an instance from `t3.micro` to `t3.large` should trigger the cost guardrail when the estimated monthly increase exceeds `$50`.

```diff
- instance_type = "t3.micro"
+ instance_type = "t3.large"
```

Expected result: CI fails if the monthly cost increase exceeds `$50`, preventing the pull request from merging until the cost impact is accepted or reduced.

## Live Validation

Live validation is available for short-lived manual testing:

```bash
RUN_LIVE=1 ./scripts/apply-and-destroy.sh
```

The `RUN_LIVE` flag is intentionally required so live cloud changes cannot happen accidentally. The script applies the infrastructure, performs validation, and destroys the resources afterward.

CI never applies or destroys infrastructure. Automated pull request checks remain plan-only to avoid unintended cloud spend.

## Design Decisions

- Plan-only CI avoids unintended infrastructure changes and cloud costs during review.
- Threshold enforcement provides a practical budget control before merge.
- Cost diffs compare against the `main` branch so reviewers see the incremental impact of each pull request.
- Environment-specific `tfvars` files keep sizing decisions explicit and reviewable.
- Tags support cost allocation, ownership, and later reporting by team, service, or environment.
- The explicit `RUN_LIVE` flag creates a safety boundary between cost estimation and real cloud execution.

## Limitations

- Infracost estimates are forecasts, not actual cloud bills.
- Discounts, credits, negotiated pricing, private pricing, taxes, and some usage-based charges may not be reflected.
- Running cost estimation requires an `INFRACOST_API_KEY`.
- Live validation requires cloud credentials and may incur short-lived infrastructure charges.

## Future Improvements

- Integrate AWS Cost Explorer for actual spend comparison
- Add anomaly detection for unusual cost changes
- Extend cost attribution to Kubernetes workloads
- Add team and namespace cost ownership reporting

## Proof / Evidence

The `docs/evidence/` directory will contain validation artifacts for the project, including:

- Infracost output
- CI pass screenshot
- CI fail screenshot
- Multi-environment comparison
- Optional AWS live validation evidence
