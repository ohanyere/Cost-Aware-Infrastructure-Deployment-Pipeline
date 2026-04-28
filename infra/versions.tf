terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region                      = var.region
  access_key                  = var.use_mock_credentials ? "mock_access_key" : null
  secret_key                  = var.use_mock_credentials ? "mock_secret_key" : null
  skip_credentials_validation = var.use_mock_credentials
  skip_metadata_api_check     = var.use_mock_credentials
  skip_requesting_account_id  = var.use_mock_credentials
}
