# terraform-guardium-demo-labs

Passos para utilização

1) Baixar o Terraform para sua plataforma
https://www.terraform.io/downloads.html

2) Seguir as instruções de instalação conforme o site do terraform

3) Criar um usuário na console AWS: https://console.aws.amazon.com/iam/home?#/users

4) Criar as chaves de acesso: https://console.aws.amazon.com/iam/home?#/users/terraform?section=security_credentials

5) Criar um arquivo chamado provider.tf no mesmo diretório dos arquivos .tf deste repositório. Incluir as seguintes informações:
provider "aws" {
  region     = var.region
  access_key = "sua-chave-de-acesso-AWS"
  secret_key = "sua-chave-secreta-AWS"
}

6) Criar um par de chaves (Key Pair) na região onde será feito o provisionamento das máquinas no EC2.
- A região está configurada no arquivo .tfvars e pode ser alterada, assim como as Availability Zones (AZs)
- O par de chaves deve ser nomeado: terraform

7) Antes de seguir para o passo 8 é necessário solicitar o compartilhamento das AMIs da solução na conta e região onde o deploy será realizado. Por favor entrar em contato comigo e enviar seu AWS Account e AWS Region.

8) Para realização da demonstracao de Tokenização é necessário me solicitar a aplicação de teste. É possível demontrar utilizando as chamadas API de tokenização e detokenização, porém é necessário criá-las. Após receber os 2 arquivos .zip, criar uma pasta apps no diretório corrente do repositório e copiar os arquivos para lá. A automação fará a copia para o servidor Linux Jump Server 1 e fará o deploy da aplicação.

9) Para executar: No diretório onde o repositório foi clonado o repositório digitar:
- terraform init ->
Esse comando irá fazer o download dos módulos necessários
- terraform plan ->
Esse comando irá listar o plano de execução e todos os recursos que serão criados
- terraform apply -auto-approve ->
Esse comando irá iniciar a execução e criação de toda a infraestrutura e configuração do GDE

Espera-se que o terraform execute sem erros. Será exibida a seguinte mensagem em caso de sucesso:
Apply complete! Resources: 27 added, 0 changed, 0 destroyed.

Logo abaixo serão exibidos alguns Outputs.
- DNS Privado dos servidores Jump, que possuem acesso direto a internet
- Endereço de IP Privado dos servidores Jump
- Endereço de IP Público dos servidores Jump: utilize esse IP para se conectar via ssh
--- Usuário do Linux Jump Servers é ubuntu

10) Após utilizar o ambiente e realizar as demonstrações executar o comando abaixo para "destruir" todos os serviços e infraestrutura
- terraform destroy

Observações:
1) Serão criadas 2 máquinas na subnet pública. Uma máquina Linux e outra Windows. Neste momento o registro do agente do GDE no DSM não está funcionando para a máquina Windows. Para a máquina Linux, favor verificar o arquivo demonstracao.txt com os passos para demonstrar a solução. Neste release a máquina Windows não será criada. Apenas a Linux.

2) Haverá custo para alocação desta infraestrutura, pois o DSM exige uma máquina fora do tier grátis oferecido pela AWS.

3) O Servidor de Tokenização precisa ser configurado manualmente (vide instruções abaixo). Para isso é preciso habilitar acesso a console web do servidor de Tokenização no seu respectivo Security Group e criar uma rota de acesso ao Internet Gateway para a Subnet Privada 1.

4) Caso ocorra o seguinte erro durante a execução "Failed to reach target state. Reason: Server.InternalError: Internal error on launch", execute o comando terraform destroy e em seguida terraform apply -auto-approve

5) O processo todo leva em torno de 26 minutos. A maioria desse tempo é devido a primeira inicialização do DSM, a qual leva uns 20 minutos.

#CONFIGURAÇÃO DO SERVIDOR DE TOKENIZAÇÃO (CTS):
User: vtsroot
pass: Guardium#123

Users -> New User:
Username: nodejs
Email: nodejs@localhost.localdomain
Password: Guardium#123
Desmarcar o checkbox Staff
Clicar em Create

Keys -> Symmetric Keys -> New Symmetric Key:
Name: CTS-AES-128
Clicar em Create Key Name

Tokenization -> Tokenization Groups -> New Tokenization Group
Name: NodeApps
Key: CTS-AES-128
Clicar em Create

Tokenization Templates -> New Tokenization Template
Name: FIRSTNAME
Character Set: Alphanumeric
Allow small inputs: marcar checkbox
Demais informações deixar default
Clicar em Create

Repetir a criação de mais 2 templates iguais ao primeiro, porém com os nomes a seguir:
Name: LASTNAME
Name: ADDRESS

Name: AGE
Character Set: All digits
Allow small inputs: marcar checkbox
Demais informações deixar default
Clicar em Create

Permissions -> Symmetric Keys
Na linha do usuário nodejs e coluna com o nome da chave CTS-AES-128, clicar em None:
Marcar as opções Tokenize e Detokenize

Configuração está pronta.
