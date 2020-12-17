resource "aws_security_group" "container_instance" {
  name_prefix = "${module.this.id}-sg-container-instance"
  description = "Security group for EC2 container instances"
  vpc_id      = var.vpc_id
  tags        = module.this.tags

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "container_instance_allow_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.container_instance.id
}

data "aws_iam_policy_document" "container_instance_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "container_instance" {
  name               = "${module.this.id}-role-container-instance"
  assume_role_policy = data.aws_iam_policy_document.container_instance_assume_role_policy.json
}

resource "aws_iam_role_policy_attachment" "container_instance_policy" {
  role       = aws_iam_role.container_instance.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_instance_profile" "container_instance" {
  name = "${module.this.id}-container-instance"
  role = aws_iam_role.container_instance.name
}

data "aws_ami" "ecs_latest" {
  most_recent = true
  owners      = ["591542846629"] # AWS

  filter {
    name   = "name"
    values = ["*amazon-ecs-optimized"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

locals {
  user_data = <<-EOT
  #!/bin/bash
  mkdir -p /etc/ecs
  echo 'ECS_CLUSTER=${aws_ecs_cluster.this.name}' >> /etc/ecs/ecs.config
  EOT
}

module "autoscale_group" {
  source  = "git::https://github.com/cloudposse/terraform-aws-ec2-autoscale-group.git?ref=0.7.4"
  context = module.this.context

  subnet_ids = var.subnet_ids

  image_id                    = data.aws_ami.ecs_latest.id
  instance_type               = var.instance_type
  user_data_base64            = base64encode(local.user_data)
  security_group_ids          = [aws_security_group.container_instance.id]
  iam_instance_profile_name   = aws_iam_instance_profile.container_instance.name
  associate_public_ip_address = true

  max_size = 1
  min_size = 1

  block_device_mappings = [
    {
      device_name  = "/dev/sda1"
      no_device    = "false"
      virtual_name = "root"
      ebs = {
        encrypted             = true
        volume_size           = var.volume_size
        delete_on_termination = true
        iops                  = null
        kms_key_id            = null
        snapshot_id           = null
        volume_type           = "gp2"
      }
    }
  ]

  autoscaling_policies_enabled = false
}
