data "aws_ami" "dsm_ami" {
  most_recent = true
  owners      = ["443003007665"]


  filter {
    name   = "name"
    values = ["dsm-aws*"]
  }
}

data "aws_ami" "cts_ami" {
  most_recent = true
  owners      = ["443003007665"]


  filter {
    name   = "name"
    values = ["cts*"]
  }
}

data "aws_ami" "gdpc_ami" {
  most_recent = true
  owners      = ["679593333241"]


  filter {
    name   = "name"
    values = ["Guardium v11.3 Collector*"]
  }
}

data "aws_ami" "win_jump_ami" {
  most_recent = true
  owners      = ["amazon"]


  filter {
    name   = "name"
    values = ["Windows_Server-2012-R2_RTM-English-64Bit-Base*"]
  }
}
/*
data "aws_ami" "linux_jump_ami" {
  most_recent = true
  owners      = ["amazon"]


  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}
*/
data "aws_ami" "linux_jump_ami" {
  most_recent = true
  owners      = ["099720109477"]


  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-20210224"]
  }
}

data "external" "whatismyip" {
  program = ["/bin/bash" , "${path.module}/scripts/whatismyip.sh"]
}

#data "external" "import_vms" {
#  program = ["/bin/bash" , "${path.module}/vm-import/import.sh"]
#}



/*
# Caso o bucket já esteja criado. Esse parte irá obter os objetos presentes no bucket
data "aws_s3_bucket_objects" "my_objects" {
  bucket = var.s3_bucket
}

data "aws_s3_bucket_object" "object_info" {
  count  = length(data.aws_s3_bucket_objects.my_objects.keys)
  key    = element(data.aws_s3_bucket_objects.my_objects.keys, count.index)
  bucket = data.aws_s3_bucket_objects.my_objects.bucket
}
*/
