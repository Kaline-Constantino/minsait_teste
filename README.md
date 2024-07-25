
# Deploy de WordPress na Azure com Terraform e Docker

Este projeto cria uma máquina virtual (VM) na Azure, instala Docker e configura containers para WordPress e um banco de dados MySQL utilizando Docker Compose. Todo o processo é automatizado com Terraform e GitHub Actions.

## Pré-requisitos

- Conta na Azure
- [Terraform](https://www.terraform.io/downloads.html) instalado
- [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli) instalado
- Conta no GitHub e acesso ao repositório

## Estrutura do Projeto

- `main.tf`: Arquivo principal do Terraform contendo a definição de todos os recursos necessários na Azure.
- `cloud-init.sh`: Script de inicialização para instalar Docker e Docker Compose na VM.
- `docker-compose.yml`: Define os containers para WordPress e banco de dados.
- `README.md`: Instruções detalhadas sobre como executar o código.

## Passo a Passo

### 1. Clonar o Repositório

Clone o repositório do GitHub para a sua máquina local:

```sh
git clone https://github.com/Kaline-Constantino/minsait_teste.git
cd minsait_teste
```

### 2. Configurar os Secrets no GitHub

Adicione os seguintes secrets no GitHub:

- `ARM_CLIENT_ID`
- `ARM_CLIENT_SECRET`
- `ARM_SUBSCRIPTION_ID`
- `ARM_TENANT_ID`

Para adicionar secrets no GitHub:

1. Vá até o repositório no GitHub.
2. Clique em **Settings**.
3. No menu lateral, clique em **Secrets** e depois em **Actions**.
4. Clique em **New repository secret** e adicione cada um dos secrets com os valores apropriados.

### 3. Inicializar e Aplicar o Terraform Manualmente

Use os comandos a seguir no prompt de comando (PowerShell ou CMD) para inicializar e aplicar o Terraform:

```sh
terraform init
terraform apply -auto-approve
```

### 4. Deploy Automático com GitHub Actions

#### Deploy Automático com Commit

Faça alterações no código e faça commit das alterações:

```sh
git add .
git commit -m "Sua mensagem de commit"
git push origin main
```

O GitHub Actions será acionado automaticamente quando um push é feito para a branch `main`. Acesse a aba **Actions** no repositório GitHub para acompanhar o progresso do deploy.

#### Deploy Automático sem Commit (Manual Trigger)

1. Acesse a aba **Actions** no repositório GitHub.
2. Selecione o workflow desejado na lista.
3. Clique no botão **Run workflow** para iniciar manualmente o workflow.

## Recursos Necessários

- **Terraform**: Ferramenta para construir, alterar e versionar infraestrutura de forma segura e eficiente.
- **Azure CLI**: Ferramenta de linha de comando da Microsoft Azure.
- **GitHub**: Plataforma de hospedagem de código-fonte e controle de versão usando Git.

## Links Úteis

- [Documentação do Terraform](https://www.terraform.io/docs)
- [Documentação do Azure CLI](https://docs.microsoft.com/en-us/cli/azure)
- [Documentação do GitHub Actions](https://docs.github.com/en/actions)

## Comentários

Cada bloco do código Terraform está comentado para facilitar o entendimento. Caso encontre problemas ou tenha dúvidas, consulte a documentação oficial do Terraform e da Azure.

## Observações

Caso o Endereço de ip publico não apareça assim que dubir a VM pode ser feito 2 coisas.
1. Rodar Novamente os comandos:
  ``` sh
terraform init
terraform apply -auto-approve
```

2. Entrar na conta da azure, Selecionar a VM que subiu junto aos comandos e copiar o endereço publico.

Nem sempre acontece do output não exibir o endereço de ip publico, mas pode ocorrer na primeira vez que sob a maquina.
