# Input Variables
# AWS Region

output "contact_person" {
  description = "creater/owner for the scripts and resources"
  value       = "vijayrmourya@gmail.com"
}

output "default_instance_type" {
  description = "EC2 Instnace Type"
  value       = "t3.medium"
}

output "default_UBUNTU_AMI_ID" {
  value = "ami-07ffb2f4d65357b42"
}

output "default_WINDOWS_AMI_ID" {
  value = "ami-077d687accca02dc1"
}

output "PERSONAL_SERVER_IP" {
  value = data.http.myip.response_body
}

output "aws_default_region" {
  description = "Region in which AWS Resources to be created"
  value       = "ap-south-1"
  #  https://registry.terraform.io/providers/hashicorp/aws/latest/docs
}

output "aws-default-azs" {
  value = ['ap-south-1a', 'ap-south-1b']
}

output "aws_user_profile" {
  value = "test_user"
}
