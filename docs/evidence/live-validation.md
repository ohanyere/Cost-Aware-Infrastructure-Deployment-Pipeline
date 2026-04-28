# Evidence: Live Validation

Live validation is optional and intentionally manual.

Command:

```bash
RUN_LIVE=1 ./scripts/apply-and-destroy.sh
```

Verification during the 60 second wait:

```bash
aws ec2 describe-instances \
  --region us-east-1 \
  --filters "Name=tag:Project,Values=cost-guardrail" "Name=tag:Environment,Values=dev" \
  --output table
```

Expected result:

```text
Terraform apply completes, one tagged EC2 instance is visible briefly, then terraform destroy removes it.
```

This was not run in the local development environment because no AWS credentials were provided.
