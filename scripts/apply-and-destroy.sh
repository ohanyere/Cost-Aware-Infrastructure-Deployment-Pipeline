#!/usr/bin/env bash
set -euo pipefail

if [[ "${RUN_LIVE:-}" != "1" ]]; then
  echo "Refusing to run live AWS validation."
  echo "This script creates real AWS resources briefly and may incur cost."
  echo "Run explicitly with: RUN_LIVE=1 ./scripts/apply-and-destroy.sh"
  exit 1
fi

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
INFRA_DIR="${ROOT_DIR}/infra"

cd "${INFRA_DIR}"

terraform init
terraform apply \
  -auto-approve \
  -var-file=example.tfvars \
  -var use_mock_credentials=false

echo "Infrastructure created. Waiting 60 seconds before destroy..."
sleep 60

terraform destroy \
  -auto-approve \
  -var-file=example.tfvars \
  -var use_mock_credentials=false
