variable "aws_default_region" {
  description = "Region in which AWS Resources to be created"
  default       = "ap-south-1"
  #  https://registry.terraform.io/providers/hashicorp/aws/latest/docs
}

variable "aws_user_profile" {
  default = "for_aws_3"
}