module "simpleInfra-vpc" {
  source = "../../terraform-modules/vpc_module"
  #  refer: https://github.com/vijayrmourya/terraform-modules

  vpc-config = local.vpc_config
}

#module "simpleInfra-igw" {
#  source = "../../terraform-modules/igw_module"
#  #  refer: https://github.com/vijayrmourya/terraform-modules
#
#  igw-config = local.igw_config
#}
#
#module "simpleInfra-subnets" {
#  source = "../../terraform-modules/subnet_module"
#  #  refer: https://github.com/vijayrmourya/terraform-modules
#
#  subnet-config = local.subnet_config
#}
#
#module "simpleInfra_route_table_and_association" {
#  source = "../../terraform-modules/routeTabe-module"
#  #  refer: https://github.com/vijayrmourya/terraform-modules
#
#  rt-igw-internet-association = local.routeTable-config
#  create_association_flag     = true
#  subnet_rt_association       = local.subnet_rt_association
#}
#
#module "testInstanceKey" {
#  source = "../../terraform-modules/ec2-key-pair"
#
#  tls_key_options = var.tlsKeyOptions
#}
#
#data "http" "myip" {
#  url = "http://ipv4.icanhazip.com"
#}
#
#module "simpleInfra-securityGroup" {
#  source = "../../terraform-modules/securityGroup-module"
#
#  securityGroupConfig = local.securityGroupConfig
#}
#
#module "simpleInfra-securityGroupRules" {
#  source = "../../terraform-modules/securityGroupRules-module"
#
#  securityRulesConfig = local.securityRulesConfig
#}
#
#resource "aws_instance" "ec2_instances-pub1" {
#  subnet_id              = aws_subnet.simpleInfra-subnet-pub1.id
#  ami                    = "ami-07ffb2f4d65357b42"
#  instance_type          = "t3.medium"
#  user_data              = file("${path.module}/testConfig.sh")
#  key_name               = aws_key_pair.ec2-key-pair.key_name
#  vpc_security_group_ids = [aws_security_group.testInstance-securityGroup.id]
#  tags                   = {
#    Name   = "simpleInfra-instance"
#    Source = "Terraform"
#  }
#}
##
##resource "aws_instance" "ec2_instances-pub2" {
##  subnet_id              = aws_subnet.simpleInfra-subnet-pub2.id
##  ami                    = "ami-07ffb2f4d65357b42"
##  instance_type          = "t3.medium"
##  user_data              = file("${path.module}/testConfig.sh")
##  key_name               = aws_key_pair.ec2-key-pair.key_name
##  vpc_security_group_ids = [aws_security_group.testInstance-securityGroup.id]
##  tags                   = {
##    Name   = "simpleInfra-instance"
##    Source = "Terraform"
##  }
##}
##
##resource "aws_instance" "ec2_instances-priv1" {
##  subnet_id              = aws_subnet.simpleInfra-subnet-priv1.id
##  ami                    = "ami-07ffb2f4d65357b42"
##  instance_type          = "t3.medium"
##  user_data              = file("${path.module}/testConfig.sh")
##  key_name               = aws_key_pair.ec2-key-pair.key_name
##  vpc_security_group_ids = [aws_security_group.testInstance-securityGroup.id]
##  tags                   = {
##    Name   = "simpleInfra-instance"
##    Source = "Terraform"
##  }
##}
##
##resource "aws_instance" "ec2_instances-priv2" {
##  subnet_id              = aws_subnet.simpleInfra-subnet-priv2.id
##  ami                    = "ami-07ffb2f4d65357b42"
##  instance_type          = "t3.medium"
##  user_data              = file("${path.module}/testConfig.sh")
##  key_name               = aws_key_pair.ec2-key-pair.key_name
##  vpc_security_group_ids = [aws_security_group.testInstance-securityGroup.id]
##  tags                   = {
##    Name   = "simpleInfra-instance"
##    Source = "Terraform"
##  }
##}
