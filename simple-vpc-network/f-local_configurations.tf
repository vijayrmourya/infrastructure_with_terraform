locals {
  vpc_config = {
    vpc_1 = {
      Name                 = var.vpc_configs.vpc_1.Name
      cidr_block           = var.vpc_configs.vpc_1.cidr_block
      instance_tenancy     = var.vpc_configs.vpc_1.instance_tenancy
      enable_dns_hostnames = var.vpc_configs.vpc_1.enable_dns_hostnames
    }
  }

  vpc_1_id = module.simpleInfra_vpc.vpc_id.vpc_1
}

locals {
  igw_config = {
    igw_1 = {
      Name   = var.igw_config.igw_1_name
      vpc_id = local.vpc_1_id
    }
  }
}

locals {
  subnet_config = {
    public_subnet_1 = {
      Name                    = var.subnet_config.public_subnet_1.Name
      cidr_block              = var.subnet_config.public_subnet_1.cidr_block
      vpc_id                  = local.vpc_1_id
      availabilityzone        = var.subnet_config.public_subnet_1.availabilityzone
      map_public_ip_on_launch = var.subnet_config.public_subnet_1.map_public_ip_on_launch
    }
    private_subnet_1 = {
      Name                    = var.subnet_config.public_subnet_2.Name
      cidr_block              = var.subnet_config.public_subnet_2.cidr_block
      vpc_id                  = local.vpc_1_id
      availabilityzone        = var.subnet_config.public_subnet_2.availabilityzone
      map_public_ip_on_launch = var.subnet_config.public_subnet_2.map_public_ip_on_launch
    }
    public_subnet_2 = {
      Name                    = var.subnet_config.private_subnet_1.Name
      cidr_block              = var.subnet_config.private_subnet_1.cidr_block
      vpc_id                  = local.vpc_1_id
      availabilityzone        = var.subnet_config.private_subnet_1.availabilityzone
      map_public_ip_on_launch = var.subnet_config.private_subnet_1.map_public_ip_on_launch
    }
    private_subnet_2 = {
      Name                    = var.subnet_config.private_subnet_2.Name
      cidr_block              = var.subnet_config.private_subnet_2.cidr_block
      vpc_id                  = local.vpc_1_id
      availabilityzone        = var.subnet_config.private_subnet_2.availabilityzone
      map_public_ip_on_launch = var.subnet_config.private_subnet_2.map_public_ip_on_launch
    }
  }
}

locals {
  routeTable_config = {
    simpleInfra_rt_main = {
      Name   = var.routeTable_config.Name
      vpc_id = local.vpc_1_id
    }
  }
}

locals {
  tlsKeyOptions = {
    testInstance_keys = {
      algorithm       = var.tlsKeyOptions.key_1.algorithm
      rsa_bits        = var.tlsKeyOptions.key_1.rsa_bits
      Key_Name        = var.tlsKeyOptions.key_1.Key_Name
      keyStorePath    = var.tlsKeyOptions.key_1.keyStorePath
      file_permission = var.tlsKeyOptions.key_1.file_permission
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
    ssh_allow_rule = {
      type      = var.securityGroupRules_config.ssh_allow_rule.type
      from_port = var.securityGroupRules_config.ssh_allow_rule.from_port
      to_port   = var.securityGroupRules_config.ssh_allow_rule.to_port
      protocol  = var.securityGroupRules_config.ssh_allow_rule.protocol
      cidr_blocks = [
        "${chomp(data.http.myip.response_body)}/32"
      ]
      ipv6_cidr_blocks  = []
      security_group_id = module.simpleInfra_securityGroup.securityGroupId.testInstanceSG
    }
    http_allow_rule = {
      type      = var.securityGroupRules_config.http_allow_rule.type
      from_port = var.securityGroupRules_config.http_allow_rule.from_port
      to_port   = var.securityGroupRules_config.http_allow_rule.to_port
      protocol  = var.securityGroupRules_config.http_allow_rule.protocol
      cidr_blocks = [
        "${chomp(data.http.myip.response_body)}/32"
      ]
      ipv6_cidr_blocks  = []
      security_group_id = module.simpleInfra_securityGroup.securityGroupId.testInstanceSG
    }
    all_egress_rule = {
      type              = var.securityGroupRules_config.all_egress_rule.type
      from_port         = var.securityGroupRules_config.all_egress_rule.from_port
      to_port           = var.securityGroupRules_config.all_egress_rule.to_port
      protocol          = var.securityGroupRules_config.all_egress_rule.protocol
      cidr_blocks       = ["0.0.0.0/0"]
      ipv6_cidr_blocks  = []
      security_group_id = module.simpleInfra_securityGroup.securityGroupId.testInstanceSG
    }
  }
}

locals {
  instances = {
    ubuntu_web_server_1 = {
      subnet_id              = module.simpleInfra_subnets.subnet_id.public_subnet_1
      ami                    = var.ec2InstanceConfig.ubuntu_instance.ami
      instance_type          = var.ec2InstanceConfig.ubuntu_instance.instance_type
      key_name               = module.testInstanceKey.ec2_key_pair_name.testInstance_keys
      vpc_security_group_ids = [module.simpleInfra_securityGroup.securityGroupId.testInstanceSG]
      instanceName           = var.ec2InstanceConfig.ubuntu_instance.instanceName1
    }
    ubuntu_web_server_2 = {
      subnet_id              = module.simpleInfra_subnets.subnet_id.private_subnet_1
      ami                    = var.ec2InstanceConfig.ubuntu_instance.ami
      instance_type          = var.ec2InstanceConfig.ubuntu_instance.instance_type
      key_name               = module.testInstanceKey.ec2_key_pair_name.testInstance_keys
      vpc_security_group_ids = [module.simpleInfra_securityGroup.securityGroupId.testInstanceSG]
      instanceName           = var.ec2InstanceConfig.ubuntu_instance.instanceName2
    }
    ubuntu_web_server_3 = {
      subnet_id              = module.simpleInfra_subnets.subnet_id.public_subnet_2
      ami                    = var.ec2InstanceConfig.ubuntu_instance.ami
      instance_type          = var.ec2InstanceConfig.ubuntu_instance.instance_type
      key_name               = module.testInstanceKey.ec2_key_pair_name.testInstance_keys
      vpc_security_group_ids = [module.simpleInfra_securityGroup.securityGroupId.testInstanceSG]
      instanceName           = var.ec2InstanceConfig.ubuntu_instance.instanceName3
    }
    ubuntu_web_server_4 = {
      subnet_id              = module.simpleInfra_subnets.subnet_id.private_subnet_2
      ami                    = var.ec2InstanceConfig.ubuntu_instance.ami
      instance_type          = var.ec2InstanceConfig.ubuntu_instance.instance_type
      key_name               = module.testInstanceKey.ec2_key_pair_name.testInstance_keys
      vpc_security_group_ids = [module.simpleInfra_securityGroup.securityGroupId.testInstanceSG]
      instanceName           = var.ec2InstanceConfig.ubuntu_instance.instanceName4
    }
  }
}
