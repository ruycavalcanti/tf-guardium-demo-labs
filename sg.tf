resource "aws_security_group" "gde_sg" {
  name = "GDE Traffic SG"
  description = "Allow traffic to GDE machines"
  vpc_id = aws_vpc.main_vpc.id

  dynamic "ingress" {
    for_each = var.sg_gde_ports
    iterator = port #this is optional
    content {
      from_port   = port.value
      to_port     = port.value
      protocol    = "tcp"
      cidr_blocks = var.public_subnets[*]
    }
  }

  dynamic "ingress" {
    for_each = var.sg_gde_internal_ports
    iterator = port #this is optional
    content {
      from_port   = port.value
      to_port     = port.value
      protocol    = "tcp"
      cidr_blocks = var.public_subnets[*]
    }
  }

  ingress {
    from_port = 0
    to_port = 0
    protocol = -1
    self = true
  }

  egress {
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "jump_sg" {
  name = "Jump Servers SG"
  description = "Allow traffic to Jump Servers"
  vpc_id = aws_vpc.main_vpc.id

  dynamic "ingress" {
    for_each = var.sg_jump_ports
    iterator = port #this is optional
    content {
      from_port   = port.value
      to_port     = port.value
      protocol    = "tcp"
      cidr_blocks = [format("%s/%s",data.external.whatismyip.result["internet_ip"],32)]
    }
  }

  dynamic "ingress" {
    for_each = var.sg_jump_internal_ports
    iterator = port #this is optional
    content {
      from_port   = port.value
      to_port     = port.value
      protocol    = "tcp"
      cidr_blocks = var.private_subnets[*]
    }
  }

  egress {
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "gdpc_sg" {
  name = "GDP Traffic SG"
  description = "Allow traffic to GDP machines"
  vpc_id = aws_vpc.main_vpc.id

  dynamic "ingress" {
    for_each = var.sg_gdpc_ports
    iterator = port #this is optional
    content {
      from_port   = port.value
      to_port     = port.value
      protocol    = "tcp"
      cidr_blocks = var.public_subnets[*]
    }
  }

  ingress {
    from_port = 0
    to_port = 0
    protocol = -1
    self = true
  }

  egress {
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
  }
}
