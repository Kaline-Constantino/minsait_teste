
# Deploy de WordPress na Azure com Terraform e Docker

## Descrição

Este projeto cria uma máquina virtual (VM) na Azure, instala Docker e configura containers para WordPress e um banco de dados MySQL utilizando Docker Compose. Todo o processo é automatizado com Terraform.

## Pré-requisitos

- Conta na Azure
- Terraform instalado
- Azure CLI instalado
- Acesso ao GitHub


## Estrutura do Projeto

- `main.tf`: Arquivo principal do Terraform contendo a definição de todos os recursos necessários na Azure.
- `cloud-init.sh`: Script de inicialização para instalar Docker e Docker Compose na VM.
- `docker-compose.yml`: Define os containers para WordPress e banco de dados.
- `README.md`: Instruções detalhadas sobre como executar o código.

## Passo a Passo

### 1. Clonar o Repositório

Clone o repositório do GitHub para a sua máquina local:

sh
`git clone https://github.com/Kaline-Constantino/minsait_teste.git`
`cd minsait_teste`

### 2. Depois use  os comandos no prompt (powershell ou cmd)
`terraform init`
`terraform apply`
