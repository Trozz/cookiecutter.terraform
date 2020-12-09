variable "assumed_role_arn" {
  type        = string
  description = "Role to be assumed for the deployment"
}

variable "region" {
  type    = string
  default = "eu-west-1"
}
