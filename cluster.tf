resource "aws_cloudwatch_log_group" "this" {
  name = "${module.this.id}-log-group"
  tags = module.this.tags
}

resource "aws_ecs_cluster" "this" {
  name = "${module.this.id}-cluster"
  tags = module.this.tags
}

resource "aws_ecs_task_definition" "this" {
  family = module.this.id

  container_definitions = templatefile("${path.module}/container-definitions.json.tpl", {
    region         = data.aws_region.current.name
    name           = module.this.id
    log_group_name = aws_cloudwatch_log_group.this.name

    image   = var.image
    command = concat(concat(concat(local.args, local.http_api_args), local.ws_api_args), local.p2p_args)

    http_api_port = var.http_api_port,
    ws_api_port   = var.ws_api_port
    p2p_port      = var.p2p_port
  })

  requires_compatibilities = ["EC2"]
  network_mode             = "host"

  volume {
    name = "data"
  }

  tags = module.this.tags
}

resource "aws_ecs_service" "this" {
  name            = module.this.id
  cluster         = aws_ecs_cluster.this.id
  desired_count   = 1
  task_definition = aws_ecs_task_definition.this.arn
  launch_type     = "EC2"
  tags            = module.this.tags
}
