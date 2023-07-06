
variable "app_name" {
  type        = string
  description = "Application Name"
  default     = "eks-cluster"
}

variable "environment" {
  type        = string
  description = "Application Environment"
  default     = "staging"
}

variable "purpose" {
  type        = string
  description = "Purpose Description"
  default     = "structure"
}

variable "cidr" {
  description = "The CIDR block for the VPC."
  default     = "10.10.0.0/16"
}

variable "public_subnets" {
  description = "List of public subnets"
  default     = ["10.10.100.0/24", "10.10.101.0/24", "10.10.102.0/24"]
}

variable "private_subnets" {
  description = "List of private subnets"
  default     = ["10.10.0.0/24", "10.10.1.0/24", "10.10.2.0/24"]
}

variable "availability_zones" {
  description = "List of availability zones"
  default     = ["ap-southeast-1a", "ap-southeast-1b", "ap-southeast-1c"]
}