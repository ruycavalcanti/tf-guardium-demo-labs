resource "null_resource" "reboot" {}

resource "time_sleep" "wait_5_minutes" {
    depends_on = [
      null_resource.reboot,
      aws_instance.jump_server[0],
      aws_instance.gde[0]
    ]
    create_duration = "5m"
}

resource "null_resource" "provisions" {

  provisioner "file" {
    source = "./terraform.pem"
    destination = "~/terraform.pem"
  }
  provisioner "file" {
    source = "./scripts/dsm_init.sh"
    destination = "~/dsm_init.sh"
  }
  provisioner "file" {
    source = "./scripts/dsm_config.sh"
    destination = "~/dsm_config.sh"
  }
  provisioner "file" {
    source = "./scripts/dsm_API_init.enc"
    destination = "~/dsm_API_init.enc"
  }
  provisioner "file" {
    source = "./scripts/dsm_API_createhost.sh"
    destination = "~/dsm_API_createhost.sh"
  }
  provisioner "file" {
    source = "./scripts/mysql_config.sh"
    destination = "~/mysql_config.sh"
  }
  provisioner "file" {
    source = "./scripts/dsm_API_LinuxGP.sh"
    destination = "~/dsm_API_LinuxGP.sh"
  }
  provisioner "file" {
    source = "./scripts/ransomware.py"
    destination = "~/.ransomware.py"
  }
  provisioner "file" {
    source = "./scripts/me_execute.sh"
    destination = "~/me_execute.sh"
  }
  provisioner "file" {
    source = "./scripts/encryptionKeyFile.key"
    destination = "~/encryptionKeyFile.key"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get -y install expect mysql-server openssl",
      "chmod +x dsm_init.sh",
      "chmod +x dsm_config.sh",
      "chmod +x dsm_API_createhost.sh",
      "chmod +x dsm_API_LinuxGP.sh",
      "chmod +x mysql_config.sh",
      "chmod +x .ransomware.py",
      "chmod +x me_execute.sh",
      "openssl enc -in dsm_API_init.enc -out dsm_API_init.sh -d -aes256 -pbkdf2 -k encryptionKeyFile.key",
      "chmod +x dsm_API_init.sh",
      "mkdir arquivos_muito_importantes_protegidos",
      "mkdir arquivos_muito_importantes_desprotegidos",
      "sudo chown root.root .ransomware.py",
      "sudo python3 .ransomware.py -g .key.key 2> /dev/null",
      "chmod 600 terraform.pem",
      "echo \"Aguardando inicializacao do DSM...\"",
      "sleep 6m",
      "./dsm_init.sh cliadmin123 no q y Guardium#123 Guardium#123 exit ssh -i terraform.pem -o \"StrictHostKeyChecking no\" cliadmin@${aws_instance.gde[0].private_ip}",
      "./dsm_config.sh Guardium#123 maintenance \"gmttimezone set America/Sao_Paulo\" up system \"setinfo hostname ${aws_instance.gde[0].private_dns}\" \"security genca\" yes exit ssh -i terraform.pem -o \"StrictHostKeyChecking no\" cliadmin@${aws_instance.gde[0].private_ip}",
      "DSMIP=${aws_instance.gde[0].private_ip}",
      "HOSTNAME=${aws_instance.jump_server[0].private_dns}",
      "DESC=\"Ubuntu Jump Server 1\"",
      "./dsm_API_init.sh $DSMIP",
      "./dsm_API_createhost.sh $DSMIP $HOSTNAME \"$DESC\" VTE 1001",
      "echo \"SERVER_HOSTNAME=${aws_instance.gde[0].private_dns}\" >> unattended.txt",
      "echo \"AGENT_HOST_NAME=${aws_instance.jump_server[0].private_dns}\" >> unattended.txt",
      "echo \"SHARED_SECRET=Guardium123!\" >> unattended.txt",
      "echo \"HOST_DOMAIN=IBM\" >> unattended.txt",
      "echo HOST_DESC=\"Ubuntu Jump Server 1\" >> unattended.txt",
      "echo \"ENABLE_LDT=1\" >> unattended.txt",
      "echo \"USEHWSIG=0\" >> unattended.txt",
      "wget https://${aws_s3_bucket.aws_bucket.bucket_domain_name}/vee-fs-7.0.0-103-ubuntu18-x86_64.bin",
      "chmod +x vee-fs-7.0.0-103-ubuntu18-x86_64.bin",
      "sudo ./vee-fs-7.0.0-103-ubuntu18-x86_64.bin -y -s unattended.txt",
      "./mysql_config.sh y 0 guardium guardium y y n n y sudo mysql_secure_installation",
      "wget https://${aws_s3_bucket.aws_bucket.bucket_domain_name}/full-backup-2021-03-30.sql",
      "wget https://${aws_s3_bucket.aws_bucket.bucket_domain_name}/demonstracao.txt",
      "cp full-backup-2021-03-30.sql arquivos_muito_importantes_protegidos/BACKUP_DB.sql",
      "cp full-backup-2021-03-30.sql arquivos_muito_importantes_desprotegidos/BACKUP_DB.sql",
      "sudo mysql -u root -pguardium < full-backup-2021-03-30.sql",
      "sudo systemctl stop mysql",
      "DSMIP=${aws_instance.gde[0].private_ip}",
      "./dsm_API_LinuxGP.sh $DSMIP",
      "sleep 2m",
      "sudo systemctl start mysql",
      "rm -f dsm_* mysql_* unattended.txt full-backup*",
      "exit"
    ]
  }

  connection {
    type = "ssh"
    user = "ubuntu"
    private_key = file("./terraform.pem")
    host = aws_instance.jump_server[0].public_ip
  }

  depends_on = [
    time_sleep.wait_5_minutes
  ]

}
