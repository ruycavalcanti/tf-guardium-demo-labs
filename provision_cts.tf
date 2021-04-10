resource "null_resource" "provision_cts" {
  depends_on = [
    null_resource.provisions,
    aws_instance.jump_server[0],
    aws_instance.gde[0],
    aws_instance.gde[1]
  ]

  connection {
    type = "ssh"
    user = "ubuntu"
    private_key = file("./terraform.pem")
    host = aws_instance.jump_server[0].public_ip
  }

  provisioner "file" {
    source = "./scripts/dsm_API_createhost.sh"
    destination = "~/dsm_API_createhost.sh"
  }

  provisioner "file" {
    source = "./scripts/cts_config.sh"
    destination = "~/cts_config.sh"
  }

  provisioner "file" {
    source = "./apps/Node-Server-Example.zip"
    destination = "~/Node-Server-Example.zip"
  }

  provisioner "file" {
    source = "./apps/Reactjs-Example.zip"
    destination = "~/Reactjs-Example.zip"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x dsm_API_createhost.sh",
      "chmod +x cts_config.sh",
      "DSMIP=${aws_instance.gde[0].private_ip}",
      "HOSTNAME=${aws_instance.gde[1].private_dns}",
      "DESC=\"CTS 1\"",
      "./dsm_API_createhost.sh $DSMIP $HOSTNAME \"$DESC\" VAE 1065",
      "./cts_config.sh q y system \"hostname --set ${aws_instance.gde[1].private_dns}\" up vae \"register ${aws_instance.gde[0].private_dns}\" up cluster \"add ${aws_instance.gde[1].private_ip}\" \"create ${aws_instance.gde[1].private_ip}\" vtsroot Guardium#123 Guardium#123 up system reboot y ssh -i terraform.pem -o \"StrictHostKeyChecking no\" cliadmin@${aws_instance.gde[1].private_ip}",
      "curl -fsSL https://www.mongodb.org/static/pgp/server-4.4.asc | sudo apt-key add -",
      "echo \"deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu bionic/mongodb-org/4.4 multiverse\" | sudo tee /etc/apt/sources.list.d/mongodb-org-4.4.list",
      "sudo apt update",
      "sudo apt install -y mongodb-org unzip",
      "sudo systemctl start mongod.service",
      "sudo systemctl enable mongod",
      "curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -",
      "sudo apt-get install -y nodejs",
      "unzip Node-Server-Example.zip",
      "unzip Reactjs-Example.zip",
      "ip=${aws_instance.gde[1].private_ip}",
      "echo \"GTO_URL=https://$ip/vts/rest/v2.0/\" >> ./Node-Server-Example/config.env",
      "sudo npm install pm2 -g",
      "cd Node-Server-Example",
      "sudo npm install -s",
      "pm2 --name NodeJS start node server.js",
      "cd ../Reactjs-Example",
      "sudo npm install -s",
      "pm2 --name ReactJS start npm -- start",
      "cd ..",
      "echo \"Aplicação de teste rodando em: ${aws_instance.jump_server[0].public_ip}:3000\"",
      "rm -f terraform.pem *.zip cts_* dsm_*",
      "exit"
    ]
  }

}
