variable "instance_type" {
  description = "EC2 instance type used for the application node."
  type        = string
  default     = "t3.micro"
}

variable "region" {
  description = "AWS region used for planning and cost estimation."
  type        = string
  default     = "us-east-1"
}

variable "project" {
  description = "Project name used for cost allocation tags."
  type        = string
}

variable "environment" {
  description = "Deployment environment used for resource tags."
  type        = string
  default     = "dev"
}

variable "owner" {
  description = "Team or person accountable for the planned infrastructure cost."
  type        = string
}

variable "ami_id" {
  description = "AMI ID used for the plan-only EC2 instance. It is not applied in CI."
  type        = string
  default     = "ami-0c02fb55956c7d316"
}

variable "use_mock_credentials" {
  description = "Use mock AWS provider credentials for plan-only local and CI runs."
  type        = bool
  default     = true
}
