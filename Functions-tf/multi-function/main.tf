provider "aws" {
  region = "us-east-1"
}

# Random ID generator for unique S3 bucket names
resource "random_id" "bucket_id" {
  byte_length = 8
}

# Define a list of instance types
variable "instance_types" {
  type    = list(string)
  default = ["t2.micro", "t3.micro", "t3.small"]
}

# Choose an instance type dynamically using element() function
resource "aws_instance" "fn-demo-inst" {
  ami           = "ami-005fc0f236362e99f"  # Example Ubuntu AMI
  instance_type = element(var.instance_types, 1) # Picks second instance type "t3.micro"
   subnet_id       = "subnet-08600bc6a3abca3df"  # Replace with an actual subnet ID
  vpc_security_group_ids = ["sg-02fd73e5ea9009850"]  # Replace with a valid security group

  tags = {
    Name = "Terraform-Instance"
  }
}

# Create an S3 bucket with a unique name
resource "aws_s3_bucket" "fn-demo-bkt" {
  bucket = format("my-terraform-bucket-%s", random_id.bucket_id.hex)

  tags = {
    Name        = "MyBucket"
    Environment = "Dev"
  }
}

# Using lookup function in map for AWS instance tags
variable "env_map" {
  type = map(string)
  default = {
    dev  = "Development"
    prod = "Production"
  }
}

output "instance_type" {
  value = aws_instance.fn-demo-inst.instance_type
}

output "bucket_name" {
  value = aws_s3_bucket.fn-demo-bkt.bucket
}

output "environment_tag" {
  value = lookup(var.env_map, "dev", "Unknown")  # Fetch 'Development' from the map
}