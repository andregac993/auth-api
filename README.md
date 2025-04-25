# 🚀 Auth API

### API de autenticação com JWT e Devise, com testes automatizados, documentação Swagger e hooks de pré-commit para garantir qualidade de código.

### Deploy feito na AWS ECR. Link Swagger: https://vz9m2whqdj.us-east-2.awsapprunner.com/api-docs/index.html

---

## ⚙️ Como rodar o projeto

## 1. Clone o repositório

```bash
    git clone git@github.com:andregac993/auth-api.git
    cd auth-api
```

## 2. Adicione os arquivos .env e .env.test com o conteúdo abaixo respectivamente

```bash
    RAILS_ENV=development
    DATABASE_HOST=db
    DATABASE_USERNAME=postgres
    DATABASE_PASSWORD=Yw4$8kPm3vRzQ1Lf9!tN5hB2xUw7EeVc
    DEVISE_JWT_SECRET_KEY=04be69c77d97573a6d3caa9ce391b212d7f1dbee71c3a6c66b9b0d8355163e62
```

```bash
    RAILS_ENV=test
    DATABASE_HOST=localhost
    DATABASE_USERNAME=postgres
    DATABASE_PASSWORD=GyazeoITltyPRVq+BP2eV4OaVh4t/tC63AxWGfDfgOA=
    DEVISE_JWT_SECRET_KEY=125d0d6b444d2f8841cd4572ca2b529034598e38be49c90c3bcc566e7e330cb7
```

## 3. Startar o projeto com o Docker

### - Buildar o projeto pela primeira vez

```bash
  docker compose up --build -d
```

### - Rode o comando abaixo para criar tanto o BD de teste quanto o de dev

```bash
  docker compose exec web rails db:create
```

### - Rode as migrations para o BD de dev

```bash
  docker compose exec web rails db:migrate
```

### - Rode as migrations para o BD de teste

```bash
  docker compose exec web rails db:migrate RAILS_ENV=test
```

## 4. Executando os testes com o Docker

#### Este projeto utiliza RSpec para testes automatizados.

```bash
  docker compose exec web bash -lc "RAILS_ENV=test bundle exec rspec"
```

## 5. Subindo um commit

#### Este projeto utiliza o Overcommit para garantir que o código esteja sempre limpo antes de ser comitado.

### Hooks configurados:

### - RuboCop

    Corrige automaticamente o estilo do código. Falha o commit se houver erros graves.

### -RSpec

    Executa todos os testes com o ambiente de testes ativo.

### - CommitMessageFormat

    Verifica se a mensagem do commit segue o padrão:

    feat: nova funcionalidade
    fix: correção de bug
    chore: tarefas administrativas
    refactor: refatoração de código
    docs: documentação
    test: testes
    style: ajustes visuais ou de formatação
    perf: melhorias de performance
    ci: integração contínua

## 📚 Documentação da API

    Acesse a documentação Swagger em:
    http://localhost:3000/api-docs