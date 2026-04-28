# Live Validation

Live validation proves that the Terraform plan can create and remove real AWS infrastructure. It is intentionally separate from CI.

## Warning

This workflow creates real AWS resources and may incur cost. Run it only in a sandbox AWS account with credentials you control. Expected runtime is under 5 minutes, including the 60 second wait before destroy.

CI never runs `terraform apply` or `terraform destroy`.

## Run

Configure AWS credentials in your shell, then run:

```bash
RUN_LIVE=1 ./scripts/apply-and-destroy.sh
```

Without `RUN_LIVE=1`, the script exits before creating anything.

## Verify

During the 60 second wait, verify the instance exists:

```bash
aws ec2 describe-instances \
  --region us-east-1 \
  --filters "Name=tag:Project,Values=cost-guardrail" "Name=tag:Environment,Values=dev" \
  --query "Reservations[].Instances[].{InstanceId:InstanceId,State:State.Name,Type:InstanceType,Owner:Tags[?Key=='Owner']|[0].Value}" \
  --output table
```

After destroy completes, rerun the command. The instance should be gone or terminated.

## Safety Notes

The live script passes `use_mock_credentials=false`, so Terraform uses normal AWS credential resolution from your environment. Keep `example.tfvars` small and short-lived.
