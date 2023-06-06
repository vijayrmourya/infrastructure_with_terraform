variable "vpc_configs" {
  type = map(object({
    Name                 = list(string)
    cidr                 = list(string)
    instance_tenancy     = list(string)
    enable_dns_hostnames = list(bool)
  }))
  default = {
    vpc-configs = {
      Name                 = ["simpleInfra_vpc"]
      cidr                 = ["10.10.0.0/20"]
      instance_tenancy     = ["default"]
      enable_dns_hostnames = [true]
    }
  }
}

variable "igw_config" {
  type = map(object({
    Name = list(string)
  }))
  name = ["simpleInfra-igw"]
}


variable "securityGroup_config" {
  default = {
    Name = "simpleInfra-testInstanceSG"
    description = "created by terraform security group module"
  }
}

locals {
  vpc_1_id   = module.simpleInfra-vpc.vpc-id["vpc-1"]
  vpc_config = {
    vpc-1 = {
      Name                 = [for config in var.vpc_configs : config.Name]
      cidr                 = [for config in var.vpc_configs : config.cidr]
      instance_tenancy     = [for config in var.vpc_configs : config.instance_tenancy]
      enable_dns_hostnames = [for config in var.vpc_configs : config.enable_dns_hostnames]
    }
  }
}

locals {
  igw_config = {
    Name   = [for config in var.igw_config : config.Name]
    vpc-id = local.vpc_1_id
  }
}



locals {
  subnet_config = {
    public-subnet-1 = {
      Name                    = var.subnet_config[0].vpc-id
      cidr                    = var.subnet_config[0].vpc-id
      vpc-id                  = var.subnet_config.vpc-id
      availabilityzone        = var.subnet_config[0].vpc-id
      map_public_ip_on_launch = var.subnet_config[0].vpc-id
    }
    public-subnet-2 = {
      Name                    = var.subnet_config[1].vpc-id
      cidr                    = var.subnet_config[1].vpc-id
      vpc-id                  = local.vpc_1_id
      availabilityzone        = var.subnet_config[1].vpc-id
      map_public_ip_on_launch = var.subnet_config[1].vpc-id
    }
    private-subnet-1 = {
      Name                    = var.subnet_config[2].vpc-id
      cidr                    = var.subnet_config[2].vpc-id
      vpc-id                  = local.vpc_1_id
      availabilityzone        = var.subnet_config[2].vpc-id
      map_public_ip_on_launch = var.subnet_config[2].vpc-id
    }
    private-subnet-2 = {
      Name                    = var.subnet_config[3].vpc-id
      cidr                    = var.subnet_config[3].vpc-id
      vpc-id                  = local.vpc_1_id
      availabilityzone        = var.subnet_config[3].vpc-id
      map_public_ip_on_launch = var.subnet_config[3].vpc-id
    }
  }
}

variable "routeTable_config" {
  type = object({
    Name = string
  })
  default = {
    Name = "simpleInfra_internt_rt"
  }
}

locals {
  routeTable_config = {
    internet-connection-rt = {
      Name   = var.routeTable_config.Name
      vpc-id = local.vpc_1_id
      route  = {
        cidr_block = "0.0.0.0/0"
        gateway_id = module.simpleInfra-igw.igw-id
      }
    }
  }
  subnet_rt_association = {
    public_sub_rt_1 = {
      subnet_id      = module.simpleInfra-subnets.subnet-id["public-subnet-1"]
      route_table_id = module.simpleInfra_route_table_and_association.public_route_table["internet-connection-rt"]
    }
    public_sub_rt_2 = {
      subnet_id      = module.simpleInfra-subnets.subnet-id["public-subnet-2"]
      route_table_id = module.simpleInfra_route_table_and_association.public_route_table["internet-connection-rt"]
    }
    private_sub_rt_1 = {
      subnet_id      = module.simpleInfra-subnets.subnet-id["private-subnet-1"]
      route_table_id = module.simpleInfra_route_table_and_association.public_route_table["internet-connection-rt"]
    }
    private_sub_rt_2 = {
      subnet_id      = module.simpleInfra-subnets.subnet-id["private-subnet-2"]
      route_table_id = module.simpleInfra_route_table_and_association.public_route_table["internet-connection-rt"]
    }
  }
}

locals {
  securityGroupConfig = {
    testInstanceSG = {
      vpc_id      = local.vpc_1_id
      name        = var.securityGroup_config.Name
      description = var.securityGroup_config.description
    }
  }
  securityRulesConfig = {
    ssh-allow-rule = {
      is_ipv6           = false
      type              = "ingress"
      from_port         = 22
      to_port           = 22
      protocol          = "tcp"
      cidr_blocks       = ["${chomp(data.http.myip.response_body)}/32"]
      security_group_id = module.simpleInfra-securityGroup.securityGroupId["testInstanceSG"]
    }
    http-allow-rule = {
      is_ipv6           = false
      type              = "ingress"
      from_port         = 80
      to_port           = 80
      protocol          = "tcp"
      cidr_blocks       = ["${chomp(data.http.myip.response_body)}/32"]
      security_group_id = module.simpleInfra-securityGroup.securityGroupId["testInstanceSG"]
    }
    all-egress-rule = {
      is_ipv6           = false
      type              = "egress"
      from_port         = 0
      to_port           = 0
      protocol          = "-1"
      cidr_blocks       = ["0.0.0.0/0"]
      security_group_id = module.simpleInfra-securityGroup.securityGroupId["testInstanceSG"]
    }
  }
}

variable "tlsKeyOptions" {
  default = {
    key-1 = {
      algorithm       = "RSA"
      rsa_bits        = 4096
      Key_Name        = "testInstanceName"
      keyStorePath    = "/../../safe-SEC_STORE/testinstances/server-private-key/test_server_key.pem"
      file_permission = "0600"
    }
  }
}