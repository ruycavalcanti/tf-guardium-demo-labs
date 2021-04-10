resource "aws_vpc_endpoint" "s3" {
  vpc_id       = aws_vpc.main_vpc.id
  service_name = "com.amazonaws.${var.region}.s3"
  vpc_endpoint_type = "Gateway"
  #associando apenas com a Subnet Publica.
  count = length(var.public_subnets)
  route_table_ids = [aws_route_table.main_public_route_table[count.index].id]
}
