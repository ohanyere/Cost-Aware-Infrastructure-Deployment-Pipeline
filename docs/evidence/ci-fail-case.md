# Evidence: CI Fail Case

Sample failing change:

```diff
- instance_type = "t3.micro"
+ instance_type = "t3.large"
```

Expected CI behavior when the monthly increase exceeds the threshold:

```text
Monthly cost diff: $52.00
Allowed monthly increase: $50.00
Cost guardrail failed: monthly increase 52.00 exceeds threshold 50.00
```

The PR still receives an Infracost comment before the threshold step fails the job.
