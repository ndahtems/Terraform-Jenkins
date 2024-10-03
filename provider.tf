terraform {
  backend "s3" {
    bucket = "jenkins-eks-bucket"
    region = "eu-central-1"
    key    = "jenkins-server/terraform.tfstate"
  }
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.52.0"
    }
  }
}

provider "aws" {
  region = "eu-central-1"
}