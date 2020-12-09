provider "aws" {
  assume_role {
    role_arn     = var.assumed_role_arn
    session_name = "Terraforming"
  }
  region  = var.region
}