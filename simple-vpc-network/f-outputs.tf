output "simpleInfra_vpc_id" {
  value = module.simpleInfra_vpc.vpc_id
}

output "simpleInfra_vpc_cidr" {
  value = module.simpleInfra_vpc.vpc_cidr
}

output "simpleInfra_subnet_id" {
  value = module.simpleInfra_subnets.subnet_id
}

output "simpleInfra_subnet_cidr" {
  value = module.simpleInfra_subnets.subnet_cidr
}

output "simpleInfra_igw" {
  value = module.simpleInfra_igw.igw_id
}

output "securityGroupId" {
  value = module.simpleInfra_securityGroup.securityGroupId
}

output "instanceKeyPairs" {
  value = module.testInstanceKey.ec2_key_pair_name
}

output "instance_public_ip" {
  value = module.simpleInfraUbuntu.instance_public_ip
}

output "instance_public_dns" {
  value = module.simpleInfraUbuntu.instance_public_dns
}

output "instance_id" {
  value = module.simpleInfraUbuntu.instance_id
}

output "privateKeyName" {
  value = module.testInstanceKey.ec2_key_pair_name
}

output "privateKeyPath" {
  value = module.testInstanceKey.local_key_path
}
