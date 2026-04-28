output "instance_type" {
  description = "EC2 instance type included in the cost estimate."
  value       = aws_instance.app.instance_type
}

output "region" {
  description = "AWS region used for the Terraform plan."
  value       = var.region
}

output "vpc_id" {
  description = "VPC ID planned for the demo stack."
  value       = aws_vpc.main.id
}
