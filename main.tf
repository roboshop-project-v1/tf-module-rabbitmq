resource "aws_security_group" "rabbitmq" {
  name        = "${local.name_prefix}-sg"
  description = "${local.name_prefix}-sg"
  vpc_id      = var.vpc_id
  tags = var.tags
}

resource "aws_vpc_security_group_ingress_rule" "rabbitmq" {
  security_group_id = aws_security_group.rabbitmq.id

  cidr_ipv4   = var.ssh_ingress_cidr
  from_port   = 22
  ip_protocol = "tcp"
  to_port     = 22
}

resource "aws_security_group_rule" "rabbitmq" {
  type              = "ingress"
  from_port         = 5672
  to_port           = 5672
  protocol          = "tcp"
  cidr_blocks       = var.sg_ingress_cidr
  security_group_id = aws_security_group.rabbitmq.id
}


resource "aws_vpc_security_group_egress_rule" "rabbitmq" {
  security_group_id = aws_security_group.rabbitmq.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports


}


resource "aws_instance" "rabbitmq" {
  ami = data.aws_ami.ami.id
  instance_type = var.instance_type
  vpc_security_group_ids = [aws_security_group.rabbitmq.id]
  subnet_id = var.subnet_ids[0]
  tags = var.tags
  user_data = "${file("${path.module}/userdata.sh")}"
  }


resource "aws_route53_record" "rabbitmq" {
  zone_id = var.zone_id
  name    = "rabbitmq-${var.env}"
  type    = "A"
  ttl     = 300
  records = [aws_instance.rabbitmq.private_ip]
}
