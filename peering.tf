provider "aws" {
    region = "us-east-1"
   # access_key = ""
   # secret_key = ""
}



module "hubmodule" {
    source = "./modules/hub"
    
}
module "spokemodules" {
    source = "./modules/spoke"
    
}
module "spoke2modules" {
    source = "./modules/spoke2"
    
}
module "spoke3modules" {
    source = "./modules/spoke3"
    
}

resource "aws_vpc_peering_connection" "peer1" {
  peer_owner_id = var.peer_owner_id
  peer_vpc_id   = module.hubmodule.hub_vpc_id
  vpc_id        = module.spokemodules.spoke1_vpc_id
  auto_accept   = true

  tags = {
    Name = "VPC Peering between spoke1 and Hub"
  }
}

#resource "aws_vpc" "spoke1" {
 # cidr_block = "172.31.0.0/16"
#}

#resource "aws_vpc" "Hub" {
 # cidr_block = "172.16.0.0/16"
#}

resource "aws_vpc_peering_connection" "peer2" {
  peer_owner_id = var.peer_owner_id
  peer_vpc_id   = module.hubmodule.hub_vpc_id
  vpc_id        = module.spoke2modules.spoke2_vpc_id
  auto_accept   = true

  tags = {
    Name = "VPC Peering between spoke2 and Hub"
  }
}

#resource "aws_vpc" "spoke2" {
 # cidr_block = "172.32.0.0/16"
#}

#resource "aws_vpc" "Hub2" {
 # cidr_block = "172.16.0.0/16"
#}

resource "aws_vpc_peering_connection" "peer3" {
  peer_owner_id = var.peer_owner_id
  peer_vpc_id   = module.hubmodule.hub_vpc_id
  vpc_id        = module.spoke3modules.spoke3_vpc_id
  auto_accept   = true

  tags = {
    Name = "VPC Peering between spoke3 and Hub"
  }
}

#resource "aws_vpc" "spoke3" {
 # cidr_block = "172.33.0.0/16"
#}

#resource "aws_vpc" "Hub" {
 # cidr_block = "172.16.0.0/16"
#}
