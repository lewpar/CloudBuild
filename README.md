# Assessment 2 - CloudBuild
This is an assessment project for my CyberSecurity Cloud unit.

This deploys:
- A VPC with 1 public subnet and 2 private subnets.
- An EC2 instance as a web server with a PHP test database index.
- An RDS instance that allows connection from the EC2 instance.
- An S3 bucket with a public access policy.

## Usage
- Install Terraform
- Run `terraform init` in root directory to setup Terraform & providers.
- Run `terraform plan` to view changes.
- Run `terraform apply` to apply changes.