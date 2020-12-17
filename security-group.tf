resource "aws_security_group" "this" {
  name_prefix = "${module.this.id}-sg"
  description = "Security group for ECS service"
  vpc_id      = var.vpc_id
  tags        = module.this.tags

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "allow_json_rpc_api_over_http" {
  count             = var.http_api_enabled ? 1 : 0
  description       = "Allow JSON RPC API over HTTP"
  type              = "ingress"
  protocol          = "tcp"
  from_port         = var.http_api_port
  to_port           = var.http_api_port
  security_group_id = aws_security_group.this.id
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "allow_json_rpc_api_over_ws" {
  count             = var.ws_api_enabled ? 1 : 0
  description       = "Allow JSON RPC API over WebSockets"
  type              = "ingress"
  protocol          = "tcp"
  from_port         = var.ws_api_port
  to_port           = var.ws_api_port
  security_group_id = aws_security_group.this.id
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "allow_p2p_tcp" {
  count             = var.p2p_enabled ? 1 : 0
  description       = "Allow node discovery over TCP"
  type              = "ingress"
  from_port         = var.p2p_port
  to_port           = var.p2p_port
  protocol          = "tcp"
  security_group_id = aws_security_group.this.id
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "allow_p2p_udp" {
  description       = "Allow node discovery over UDP"
  type              = "ingress"
  from_port         = var.p2p_port
  to_port           = var.p2p_port
  protocol          = "udp"
  security_group_id = aws_security_group.this.id
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "allow_egress" {
  description       = "Allow egress"
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.this.id
}
