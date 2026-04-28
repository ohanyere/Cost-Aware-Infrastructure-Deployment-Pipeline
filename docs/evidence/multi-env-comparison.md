# Evidence: Multi-Environment Comparison

Sample comparison:

| Environment | Instance type | Sample monthly estimate |
| --- | --- | ---: |
| dev | `t3.micro` | ~$8 |
| staging | `t3.small` | ~$16 |
| prod | `t3.medium` | ~$30 |

The exact values depend on AWS region, pricing updates, and Infracost usage assumptions.

Evidence command:

```bash
./scripts/cost.sh
```
