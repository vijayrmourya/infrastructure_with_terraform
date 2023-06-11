variable "vpc_configs" {
  default = {
    vpc_1 = {
      Name                 = "simpleInfra_vpc"
      cidr_block           = "10.10.0.0/20"
      instance_tenancy     = "default"
      enable_dns_hostnames = true
    }
  }
}

variable "igw_config" {
  default = {
    igw_1_name = "simpleInfra_igw"
  }
}


variable "subnet_config" {
  default = {
    public_subnet_1 = {
      Name                    = "simpleInfra_public_1"
      cidr_block              = "10.10.0.0/22"
      availabilityzone        = "ap-south-1a"
      map_public_ip_on_launch = true
    }
    private_subnet_1 = {
      Name                    = "simpleInfra_public_2"
      cidr_block              = "10.10.4.0/22"
      availabilityzone        = "ap-south-1a"
      map_public_ip_on_launch = false
    }
    public_subnet_2 = {
      Name                    = "simpleInfra_private_1"
      cidr_block              = "10.10.8.0/22"
      availabilityzone        = "ap-south-1b"
      map_public_ip_on_launch = true
    }
    private_subnet_2 = {
      Name                    = "simpleInfra_private_2"
      cidr_block              = "10.10.12.0/22"
      availabilityzone        = "ap-south-1b"
      map_public_ip_on_launch = false
    }
  }
}

variable "routeTable_config" {
  default = {
    Name = "simpleInfra_internt_rt"
  }
}

variable "tlsKeyOptions" {
  default = {
    key_1 = {
      algorithm       = "RSA"
      rsa_bits        = 4096
      Key_Name        = "testInstanceName"
      keyStorePath    = "simpleInfra/test_server_key.pem"
      file_permission = "0600"
    }
  }
}

variable "securityGroup_config" {
  default = {
    sg_1 = {
      Name        = "simpleInfra_testInstanceSG"
      description = "created by terraform security group module"
    }
  }
}

variable "securityGroupRules_config" {
  default = {
    ssh_allow_rule = {
      type      = "ingress"
      from_port = 22
      to_port   = 22
      protocol  = "tcp"
    }
    http_allow_rule = {
      type      = "ingress"
      from_port = 80
      to_port   = 80
      protocol  = "tcp"
    }
    all_egress_rule = {
      type      = "egress"
      from_port = 0
      to_port   = 0
      protocol  = "-1"
    }
  }
}

variable "ec2InstanceConfig" {
  default = {
    ubuntu_instance = {
      ami           = "ami-07ffb2f4d65357b42"
      instance_type = "t2.micro"
      instanceName1 = "TestInstance_1"
      instanceName2 = "TestInstance_2"
      instanceName3 = "TestInstance_3"
      instanceName4 = "TestInstance_4"
    }
  }
}