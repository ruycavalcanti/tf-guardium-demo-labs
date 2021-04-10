resource "aws_instance" "gde" {
  count = length(var.servidores_GDE)

  ami = count.index > 0 ? data.aws_ami.cts_ami.id : data.aws_ami.dsm_ami.id
  instance_type = element(values(var.servidores_GDE), count.index)
  key_name = var.ec2_key_name
  subnet_id = aws_subnet.main_private_subnet[substr(element(keys(var.servidores_GDE), count.index), length(element(keys(var.servidores_GDE), count.index)) - 1, 1) - 1].id
  vpc_security_group_ids = [aws_security_group.gde_sg.id]

  tags = {
    Name = element(keys(var.servidores_GDE), count.index)
  }
}

resource "aws_instance" "jump_server" {
  count = length(var.servidores_JUMP)

  ami = substr(element(keys(var.servidores_JUMP), count.index), 0, 3) == "Win" ? data.aws_ami.win_jump_ami.id : data.aws_ami.linux_jump_ami.id
  instance_type = element(values(var.servidores_JUMP), count.index)
  key_name = var.ec2_key_name
  subnet_id = aws_subnet.main_public_subnet[substr(element(keys(var.servidores_JUMP), count.index), length(element(keys(var.servidores_JUMP), count.index)) - 1, 1) - 1].id
  vpc_security_group_ids = [aws_security_group.jump_sg.id]
  user_data = substr(element(keys(var.servidores_JUMP), count.index), 0, 3) == "Win" ? data.template_cloudinit_config.cloudinit-windows-jump_server.rendered : data.template_cloudinit_config.cloudinit-linux-jump_server.rendered
  get_password_data = substr(element(keys(var.servidores_JUMP), count.index), 0, 3) == "Win" ? "true" : "false"

  tags = {
    Name = element(keys(var.servidores_JUMP), count.index)
  }

  depends_on = [ aws_s3_bucket_object.objects ]
}

resource "aws_instance" "gdpc" {
  count = length(var.servidores_GDP)

  ami = data.aws_ami.gdpc_ami.id
  instance_type = element(values(var.servidores_GDP), count.index)
  key_name = var.ec2_key_name
  subnet_id = aws_subnet.main_private_subnet[substr(element(keys(var.servidores_GDP), count.index), length(element(keys(var.servidores_GDP), count.index)) - 1, 1) - 1].id

  /*
  root_block_device {
    volume_size = 50
  }
  */
  vpc_security_group_ids = [aws_security_group.gdpc_sg.id]

  tags = {
    Name = element(keys(var.servidores_GDP), count.index)
  }
}
/*
resource "aws_instance" "osprey" {
  ami = "A ser preenchida"
  instance_type = "t2.micro"
  key_name = var.ec2_key_name
  subnet_id = aws_subnet.main_private_subnet[0].id


  vpc_security_group_ids = [aws_security_group.jump_sg.id]

  depends_on = [
    aws_s3_bucket_object.objects
  ]

  tags = {
    Name = "Osprey 20200224"
  }
}
*/

output "jump_servers_public_ips" {
  value = aws_instance.jump_server[*].public_ip
}

output "jump_servers_private_ips" {
  value = aws_instance.jump_server[*].private_ip
}
output "gde_servers_public_ips" {
  value = aws_instance.gde[*].public_ip
}
