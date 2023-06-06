variable "vpc_configs" {
  type = map(object({
    Name                 = string
    cidr                 = string
    instance_tenancy     = string
    enable_dns_hostnames = bool
  }))
  default = {
    vpc_1 = {
      Name                 = "simpleInfra_vpc"
      cidr                 = "10.10.0.0/20"
      instance_tenancy     = "default"
      enable_dns_hostnames = true
    }
  }
}

variable "igw_config" {
  type = map(object({
    Name = string
  }))
  default = {
    igw_1 = {
      Name = "simpleInfra-igw"
    }
  }
}

variable "subnet_config" {
  type = map(object({
    Name                    = string
    cidr                    = string
    availabilityzone        = string
    map_public_ip_on_launch = bool
  }))
  default = {
    public-subnet-1 = {
      Name                    = "simpleInfra-public-1"
      cidr                    = "10.10.0.0/22"
      availabilityzone        = "ap-south-1a"
      map_public_ip_on_launch = true
    }
    public-subnet-2 = {
      Name                    = "simpleInfra-public-2"
      cidr                    = "10.10.4.0/22"
      availabilityzone        = "ap-south-1a"
      map_public_ip_on_launch = false
    }
    private-subnet-1 = {
      Name                    = "simpleInfra-private-1"
      cidr                    = "10.10.8.0/22"
      availabilityzone        = "ap-south-1b"
      map_public_ip_on_launch = true
    }
    private-subnet-2 = {
      Name                    = "simpleInfra-private-2"
      cidr                    = "10.10.12.0/22"
      availabilityzone        = "ap-south-1b"
      map_public_ip_on_launch = false
    }
  }
}

variable "routeTable_config" {
  type = object({
    Name                = string
    create_associations = bool
  })
  default = {
    Name                = "simpleInfra_internt_rt"
    create_associations = true
  }
}

variable "securityGroup_config" {
  type = map(object({
    Name        = string
    description = string
  }))
  default = {
    sg_1 = {
      Name        = "simpleInfra-testInstanceSG"
      description = "created by terraform security group module"
    }
  }
}

variable "securityGroupRules_config" {
  type = map(object({
    is_ipv6   = bool
    type      = string
    from_port = number
    to_port   = number
    protocol  = string
  }))
  default = {
    ssh-allow-rule = {
      is_ipv6   = false
      type      = "ingress"
      from_port = 22
      to_port   = 22
      protocol  = "tcp"
    }
    http-allow-rule = {
      is_ipv6   = false
      type      = "ingress"
      from_port = 80
      to_port   = 80
      protocol  = "tcp"
    }
    all-egress-rule = {
      is_ipv6   = false
      type      = "egress"
      from_port = 0
      to_port   = 0
      protocol  = "-1"
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