# Evidence: CI Pass Case

Sample passing change:

```hcl
instance_type = "t3.micro"
```

Expected CI behavior:

```text
Monthly cost diff: $0.00
Allowed monthly increase: $50.00
Cost guardrail passed: monthly increase 0.00 is within threshold 50.00
```

The PR receives an Infracost comment and the required check passes.
