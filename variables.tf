variable "azs" {
  type = list
}

variable "private_subnets" {
  description = "Lista de Subnets Privadas"
  type = list
}

variable "public_subnets" {
  description = "Lista de Subnets Públicas"
  type = list
}

variable "region" {
  description = "Região de criação da VPC"
  default = "us-east-1"
}

variable "servidores_GDE" {
  description = "Mapa de Servidores GDE vs Tipo de Instancia do Ambiente. Criar nome com sintaxe: <SO + nome_do_servico + id_subnet>"
  type = map
}

variable "servidores_GDP" {
  description = "Mapa de Servidores GDP vs Tipo de Instancia do Ambiente. Criar nome com sintaxe: <SO + nome_do_servico + id_subnet>"
  type = map
}

variable "servidores_JUMP" {
  description = "Mapa de Jump Servers vs Tipo de Instancia do Ambiente. Criar nome com sintaxe: <SO + nome_do_servico + id_subnet>"
  type = map
}

variable "sg_gde_ports" {
  type        = list(number)
  description = "Portas para SG GDE"
  default     = [22, 443]
}

variable "sg_jump_ports" {
  type        = list(number)
  description = "Portas para SG Jump Servers"
  default     = [22, 443]
}

variable "sg_jump_internal_ports" {
  type        = list(number)
  description = "Portas para SG Jump Servers: DSM -> Agente"
}

variable "sg_gde_internal_ports" {
  type        = list(number)
  description = "Portas para SG GDE: Agente -> DSM"
}

variable "sg_gdpc_ports" {
  type        = list(number)
  description = "Portas para SG GDP Collector"
  default     = [22, 8443]
}

variable "s3_bucket" {
  description = "Nome do Bucket S3 para armazenamento de scripts e agentes"
  default = "lab-demo-security-bucket"
}

variable "ec2_key_name" {
  description = "Nome da chave criptográfica criada para acessar as máquinas no EC2"
}
