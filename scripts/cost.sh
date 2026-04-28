#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
INFRA_DIR="${ROOT_DIR}/infra"
ENVS=("dev" "staging" "prod")

cd "${INFRA_DIR}"

terraform init
terraform validate

for env in "${ENVS[@]}"; do
  echo
  echo "== ${env} cost estimate =="

  terraform plan \
    -out "tfplan-${env}.binary" \
    -var-file="envs/${env}.tfvars"

  terraform show -json "tfplan-${env}.binary" > "plan-${env}.json"

  infracost breakdown \
    --path . \
    --terraform-var-file "envs/${env}.tfvars" \
    --format table
done
