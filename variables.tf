variable "vpc_id" {
  type        = string
  description = "var for VPC ID"
  default     = "vpc-0aba86c88dc8b74b3"
}

variable "cidr_open" {
  type        = string
  description = "CIDR block to allow traffic from anywhere"
  default     = "0.0.0.0/0"
}

variable "cidr_vpc" {
  type        = string
  description = "CIDR block to allow traffic from local machine"
  default     = "172.31.0.0/16"
}

variable "s3_bucket" {
  type        = string
  description = "S3 bucket"
  default     = "projects34758463648"
}

variable "instance_type" {
  type        = string
  description = "var for instance type"
  default     = "t2.micro"
}

variable "ami_id" {
  type        = string
  description = "var for AMI ID"
  default     = "ami-04581fbf744a7d11f"
}

variable "availability_zone_a" {
  type    = string
  default = "us-east-1a"
}

variable "availability_zone_b" {
  type    = string
  default = "us-east-1b"
}