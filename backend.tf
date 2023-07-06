terraform {
  backend "s3" {
    bucket = "change-me"
    key    = "terraform/eks-cluster/terraform.tfstate"
    region = "us-east-1"
  }
}
