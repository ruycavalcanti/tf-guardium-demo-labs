resource "aws_s3_bucket" "aws_bucket" {
  bucket = var.s3_bucket
  acl    = "public-read"

  tags = {
    Name        = "Lab Demo Bucket"
    Environment = "Demo"
  }
}
/*
resource "aws_s3_bucket_object" "cte_win_agent_bucket_object" {
  key                    = "vee-fs-7.0.0-76-win64.msi"
  bucket                 = aws_s3_bucket.aws_bucket.id
  acl = "public-read"
  source                 = "${path.module}/arquivos-s3/vee-fs-7.0.0-76-win64.msi"
}

resource "aws_s3_bucket_object" "cte_linux_agent_bucket_object" {
  key                    = "vee-fs-7.0.0-47-amzn2017-x86_64.bin"
  bucket                 = aws_s3_bucket.aws_bucket.id
  acl = "public-read"
  source                 = "${path.module}/arquivos-s3/vee-fs-7.0.0-47-amzn2017-x86_64.bin"
}
*/

#fazer upload de vários arquivoss
resource "aws_s3_bucket_object" "objects" {
  for_each = fileset("arquivos-s3/", "*")
  bucket = aws_s3_bucket.aws_bucket.id
  key = each.value
  acl = "public-read"
  source = "arquivos-s3/${each.value}"
}
