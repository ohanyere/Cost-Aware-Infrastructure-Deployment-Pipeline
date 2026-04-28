# Tagging and Cost Allocation

All Terraform-managed resources include consistent tags:

```hcl
Project     = var.project
Environment = var.environment
Owner       = var.owner
ManagedBy   = "terraform"
```

## Why Tags Matter

Tags connect cloud spend to ownership. Without tags, teams see a bill but cannot reliably answer who owns a resource, what environment it supports, or whether it should still exist.

## FinOps Usage

FinOps teams use tags to:

- allocate spend to teams, products, and environments
- identify cost increases by owner
- build budget reports and chargeback/showback views
- find unowned or stale infrastructure

## AWS Cost Explorer

In AWS, cost allocation tags can be activated in the Billing console. After activation, Cost Explorer can group and filter cost by tags such as `Project`, `Environment`, and `Owner`.

This project uses those tags consistently so the same metadata appears in Terraform plans, Infracost output, and AWS billing workflows.
