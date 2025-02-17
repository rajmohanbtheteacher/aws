module "vpc" {
  source         = "./modules/vpc"
  vpc_cidr       = var.vpc_cidr
  public_subnets = var.public_subnets
  private_subnets = var.private_subnets
}

module "security" {
  source = "./modules/security"
  vpc_id = module.vpc.vpc_id
}

module "alb" {
  source  = "./modules/alb"
  vpc_id  = module.vpc.vpc_id
  public_sg_id = module.security.public_sg_id
  public_subnet_ids = module.vpc.public_subnet_ids
}

module "asg" {
  source  = "./modules/asg"
  private_subnet_ids = module.vpc.private_subnet_ids
  ami_id = var.ami_id
  instance_type = var.instance_type
  min_size = module.asg.min_size
  desired_capacity = module.asg.desired_capacity
  max_size = moduule.asg.max_size
}

module "secrets" {
  source = "./modules/secrets"
  dockerhub_username = var.dockerhub_username
  dockerhub_password = var.dockerhub_password
}