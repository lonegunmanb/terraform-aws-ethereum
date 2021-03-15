module "vpc" {
  source     = "git::https://github.com/cloudposse/terraform-aws-vpc.git?ref=0.21.1"
  context    = module.this.context
  cidr_block = "10.0.0.0/16"
}

data "aws_availability_zones" "available" {
  state = "available"
}

module "subnets" {
  source              = "git::https://github.com/cloudposse/terraform-aws-dynamic-subnets.git?ref=0.38.0"
  context             = module.this.context
  vpc_id              = module.vpc.vpc_id
  igw_id              = module.vpc.igw_id
  cidr_block          = module.vpc.vpc_cidr_block
  availability_zones  = slice(data.aws_availability_zones.available.names, 0, 2)
  nat_gateway_enabled = true
}

module "ethereum_node" {
  source  = "../../"
  context = module.this.context

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.subnets.public_subnet_ids
}
