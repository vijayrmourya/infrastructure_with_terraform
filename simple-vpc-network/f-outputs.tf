output "simpleInfra-vpc-id" {
  value = module.simpleInfra-vpc.vpc-id
}

output "simpleInfra-subnet-id" {
  value = module.simpleInfra-subnets.subnet-id
}

output "simpleInfra-igw" {
  value = module.simpleInfra-igw.igw-id
}

output "securityGroupId" {
  value = module.simpleInfra-securityGroup.securityGroupId
}

output "instanceKeyPairs" {
  value = module.testInstanceKey.ec2_key_pair_name
}