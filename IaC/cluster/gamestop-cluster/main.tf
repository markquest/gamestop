#Create a provider
provider "aws" {
  region    = var.region
}


#Create vpc
module "vpc" {
  source                      = "../modules/vpc"
  region                      = var.region
  project_name                = var.project_name
  vpc_cidr                    = var.vpc_cidr
  public_subnet_az1_cidr      = var.public_subnet_az1_cidr
  public_subnet_az2_cidr      = var.public_subnet_az2_cidr 
  private_app_subnet_az1_cidr = var.private_app_subnet_az1_cidr
  private_app_subnet_az2_cidr = var.private_app_subnet_az2_cidr
}


module "control-plane-security-group" {
  source = "../modules/sec-grp"
  vpc_id = module.vpc.vpc_id
  
}


resource "aws_instance" "kube-master" {
    ami = var.ami
    instance_type = var.instance_type
    iam_instance_profile = aws_iam_instance_profile.gamestop-kube-master-profile.name
    security_groups = [module.control-plane-security-group.control_plane_sec_grp_id]
    # security_groups = [module.control-plane-security-group.control_plane_sec_grp_id]
    key_name = "firstkeymac"
    subnet_id = module.vpc.public_subnet_az1_id  # select own subnet_id of us-east-1a
    tags = {
        Name = "kube-master"
        Project = "gamestop"
        # Role = "master"
        # Id = "1"
        environment = "test"
    }
}

#Create worker node
module "worker-node-security-group" {
  source = "../modules/sec-grp"
  vpc_id = module.vpc.vpc_id
  
}


resource "aws_instance" "kube-worker" {
    count           = 2
    ami             = var.ami
    instance_type   = var.instance_type
    security_groups = [module.worker-node-security-group.worker_node_sec_grp_id]
    # security_groups = [module.worker-node-security-group.worker_node_sec_grp_id]
    key_name        = "firstkeymac"
    subnet_id       = module.vpc.public_subnet_az1_id  # select own subnet_id of us-east-1a
    tags = {
        Name = "kube-worker-${count.index + 1}"
        Project = "gamestop"
        # Role = "master"
        # Id = "1"
        environment = "test"
    }
}