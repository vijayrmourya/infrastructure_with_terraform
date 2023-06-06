locals {
  vpc_config = {
    vpc-1 = {
      Name                 = var.vpc_configs.vpc_1.Name
      cidr                 = var.vpc_configs.vpc_1.cidr
      instance_tenancy     = var.vpc_configs.vpc_1.instance_tenancy
      enable_dns_hostnames = var.vpc_configs.vpc_1.enable_dns_hostnames
    }
  }

  vpc_1_id = module.simpleInfra-vpc.vpc-id.vpc-1
}

locals {
  igw_config = {
    igw_1 = {
      Name   = var.igw_config.igw_1.Name
      vpc-id = local.vpc_1_id
    }
  }
}

locals {
  subnet_config = {
    public-subnet-1 = {
      Name                    = var.subnet_config.public-subnet-1.Name
      cidr                    = var.subnet_config.public-subnet-1.cidr
      vpc-id                  = local.vpc_1_id
      availabilityzone        = var.subnet_config.public-subnet-1.availabilityzone
      map_public_ip_on_launch = var.subnet_config.public-subnet-1.map_public_ip_on_launch
    }
    public-subnet-2 = {
      Name                    = var.subnet_config.public-subnet-2.Name
      cidr                    = var.subnet_config.public-subnet-2.cidr
      vpc-id                  = local.vpc_1_id
      availabilityzone        = var.subnet_config.public-subnet-2.availabilityzone
      map_public_ip_on_launch = var.subnet_config.public-subnet-2.map_public_ip_on_launch
    }
    private-subnet-1 = {
      Name                    = var.subnet_config.private-subnet-1.Name
      cidr                    = var.subnet_config.private-subnet-1.cidr
      vpc-id                  = local.vpc_1_id
      availabilityzone        = var.subnet_config.private-subnet-1.availabilityzone
      map_public_ip_on_launch = var.subnet_config.private-subnet-1.map_public_ip_on_launch
    }
    private-subnet-2 = {
      Name                    = var.subnet_config.private-subnet-2.Name
      cidr                    = var.subnet_config.private-subnet-2.cidr
      vpc-id                  = local.vpc_1_id
      availabilityzone        = var.subnet_config.private-subnet-2.availabilityzone
      map_public_ip_on_launch = var.subnet_config.private-subnet-2.map_public_ip_on_launch
    }
  }
}

locals {
  routeTable_config = {
    internet-connection-rt = {
      Name   = var.routeTable_config.Name
      vpc-id = local.vpc_1_id
      route = {
        cidr_block = "0.0.0.0/0"
        gateway_id = module.simpleInfra-igw.igw-id
      }
    }
  }
  create_associations = var.routeTable_config.create_associations
  subnet_rt_association = {
    public_sub_rt_1 = {
      subnet_id      = module.simpleInfra-subnets.subnet-id.public-subnet-1
      route_table_id = module.simpleInfra_route_table_and_association.public_route_table.internet-connection-rt
    }
    public_sub_rt_2 = {
      subnet_id      = module.simpleInfra-subnets.subnet-id.public-subnet-2
      route_table_id = module.simpleInfra_route_table_and_association.public_route_table.internet-connection-rt
    }
    private_sub_rt_1 = {
      subnet_id      = module.simpleInfra-subnets.subnet-id.private-subnet-1
      route_table_id = module.simpleInfra_route_table_and_association.public_route_table.internet-connection-rt
    }
    private_sub_rt_2 = {
      subnet_id      = module.simpleInfra-subnets.subnet-id.private-subnet-2
      route_table_id = module.simpleInfra_route_table_and_association.public_route_table.internet-connection-rt
    }
  }
}

locals {
  securityGroupConfig = {
    testInstanceSG = {
      vpc_id      = local.vpc_1_id
      name        = var.securityGroup_config.sg_1.Name
      description = var.securityGroup_config.sg_1.description
    }
  }
}

locals {
  securityRulesConfig = {
    ssh-allow-rule = {
      is_ipv6   = var.securityGroupRules_config.ssh-allow-rule.is_ipv6
      type      = var.securityGroupRules_config.ssh-allow-rule.type
      from_port = var.securityGroupRules_config.ssh-allow-rule.from_port
      to_port   = var.securityGroupRules_config.ssh-allow-rule.to_port
      protocol  = var.securityGroupRules_config.ssh-allow-rule.protocol
      cidr_blocks = [
        "${chomp(data.http.myip.response_body)}/32"
      ]
      ipv6_cidr_blocks  = []
      security_group_id = module.simpleInfra-securityGroup.securityGroupId.testInstanceSG
    }
    http-allow-rule = {
      is_ipv6   = var.securityGroupRules_config.http-allow-rule.is_ipv6
      type      = var.securityGroupRules_config.http-allow-rule.type
      from_port = var.securityGroupRules_config.http-allow-rule.from_port
      to_port   = var.securityGroupRules_config.http-allow-rule.to_port
      protocol  = var.securityGroupRules_config.http-allow-rule.protocol
      cidr_blocks = [
        "${chomp(data.http.myip.response_body)}/32"
      ]
      ipv6_cidr_blocks  = []
      security_group_id = module.simpleInfra-securityGroup.securityGroupId.testInstanceSG
    }
    all-egress-rule = {
      is_ipv6           = var.securityGroupRules_config.all-egress-rule.is_ipv6
      type              = var.securityGroupRules_config.all-egress-rule.type
      from_port         = var.securityGroupRules_config.all-egress-rule.from_port
      to_port           = var.securityGroupRules_config.all-egress-rule.to_port
      protocol          = var.securityGroupRules_config.all-egress-rule.protocol
      cidr_blocks       = ["0.0.0.0/0"]
      ipv6_cidr_blocks  = []
      security_group_id = module.simpleInfra-securityGroup.securityGroupId.testInstanceSG
    }
  }
}

locals {
  tlsKeyOptions = {
    testInstance-keys = {
      algorithm       = var.tlsKeyOptions.key-1.algorithm
      rsa_bits        = var.tlsKeyOptions.key-1.rsa_bits
      Key_Name        = var.tlsKeyOptions.key-1.Key_Name
      keyStorePath    = var.tlsKeyOptions.key-1.keyStorePath
      file_permission = var.tlsKeyOptions.key-1.file_permission
    }
  }
}