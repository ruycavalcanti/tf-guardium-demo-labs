azs = ["us-east-1a", "us-east-1b", "us-east-1c"]
private_subnets = ["10.0.2.0/24", "10.0.3.0/24"]
public_subnets = ["10.0.1.0/24"]
region = "us-east-1"
servidores_JUMP={
  "Linux Jump 1" = "t2.micro",
  #"Windows Jump 1" = "t2.micro"
}
servidores_GDE={
  "DSM 1" = "t2.large",
  #"DSM 2" = "t2.large",
  "GTO 1" = "t2.xlarge",
  #"GTO 2" = "t2.xlarge"
}
servidores_GDP={
  #"Collector 1" = "m4.2xlarge"
}
sg_gde_ports=[22, 443]
sg_gde_internal_ports=[8080, 8443, 8444, 8446, 8447]
sg_jump_internal_ports=[7024]
sg_jump_ports=[22, 443, 3000, 3389, 5985, 5986]
sg_gdpc_ports=[22, 8443, 8444, 8445, 8446, 8081, 16022, 16023, 16016, 16017, 16018, 9500, 9501, 8983, 9983]
s3_bucket="lab-demo-security-bucket"
ec2_key_name="terraform"
