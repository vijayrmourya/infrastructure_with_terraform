module "simpleInfra_vpc" {
  source = "../../terraform_modules/vpc_module"
  #  refer: https://github.com/vijayrmourya/terraform_modules

  vpc_config = local.vpc_config
}

module "simpleInfra_igw" {
  source = "../../terraform_modules/igw_module"
  #  refer: https://github.com/vijayrmourya/terraform_modules

  igw_config = local.igw_config
}

module "simpleInfra_subnets" {
  source = "../../terraform_modules/subnet_module"
  #  refer: https://github.com/vijayrmourya/terraform_modules

  subnet_config = local.subnet_config
}

module "simpleInfra_route_table" {
  source = "../../terraform_modules/routeTabe_module"
  #  refer: https://github.com/vijayrmourya/terraform_modules

  route_table_config = local.routeTable_config
}

resource "aws_route" "public_route" {
  route_table_id         = module.simpleInfra_route_table.route_table_id.simpleInfra_rt_main
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = module.simpleInfra_igw.igw_id.igw_1
}

resource "aws_route_table_association" "public_route_association_1a" {
  route_table_id = module.simpleInfra_route_table.route_table_id.simpleInfra_rt_main
  subnet_id      = module.simpleInfra_subnets.subnet_id.public_subnet_1
}

resource "aws_route_table_association" "public_route_association_1b" {
  route_table_id = module.simpleInfra_route_table.route_table_id.simpleInfra_rt_main
  subnet_id      = module.simpleInfra_subnets.subnet_id.public_subnet_2
}

module "testInstanceKey" {
  source = "../../terraform_modules/ec2_key_pair"

  ec2_key_config = local.tlsKeyOptions
}

data "http" "myip" {
  url = "http://ipv4.icanhazip.com"
}

module "simpleInfra_securityGroup" {
  source = "../../terraform_modules/securityGroup_module"

  securityGroup_Config = local.securityGroupConfig
}

module "simpleInfra_securityGroupRules" {
  source = "../../terraform_modules/securityGroupRules_module"

  securityGroupRules_Config = local.securityRulesConfig
}

module "simpleInfraUbuntu" {
  source = "../../terraform_modules/ec2_instance"

  ec2Instance_Config = local.instances
}