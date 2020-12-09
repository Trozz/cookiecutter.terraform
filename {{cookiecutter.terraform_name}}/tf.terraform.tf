terraform {
  required_version = ">= {{cookiecutter.terraform_version}}"

  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 3.20"
    }
  }
}
