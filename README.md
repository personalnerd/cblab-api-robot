# CB LAB Desafio QA - Teste de API

Este repositório contém o código de teste de API para o desafio de QA utilizando Robot Framework.

## Descrição

O projeto objetiva automatizar testes das rotas `addcart`, `updatecart` e `deletecart` da API [DummyJson](https://dummyjson.com/), utilizando o [Robot Framework](https://robotframework.org/).

Utilizei os endpoints com autenticação, em vez dos endpoints simples, pois quis adicionar testes de falha de autenticação.

Para os testes de API, optei pelo Robot Framework para sair da minha zona de conforto e exercitar um dos frameworks solicitados no desafio, sendo também o framework que considero mais fácil de automatizar testes de API, mesmo comparando com o Playwright.

## Estrutura do Projeto

- `resources/data/`: Organização de variáveis a serem utilizadas em todo o projeto
- `resources/pages/`: Contém os objetos de página (Page Objects) que abstraem a interação com as rotas
- `resources/shared/`: objetos de página compartilháveis (keywords de asserções) e úteis (setup e teardown)
- `suites/`: Os testes em si, em suites organizadas por rotas.
- `package.json`: Não é estritamente necessário para um projeto Robot Framework, mas adicionei para facilitar a execução dos testes utilizando scripts npm.

## Pré-requisitos

- Python (versão 3.13.2 ou superior)
- pip (versão 25.0.1 ou superior)
- Robot Framework (versão 7.2.2 ou superior)
- Requests Library (versão 0.9.7 ou superior)

Opcionais:

- Node.js (versão 14 ou superior) - apenas se quiser utilizar os scripts do arquivo `package.json`
- npm (gerenciador de pacotes do Node.js) - idem

## Instalação

É pré-requisito ter o Python instalado na máquina. [Download](https://www.python.org/downloads/).

Após instalar o Python, verifique se o Pip — gerenciador de pacotes do Python — também está instalado. Ele deve vir instalado por padrão. Confira com os comandos abaixo:

```bash
$ python --version
Python 3.13.2

$ pip --version
pip 25.0.1
```

Instale o Robot Framework:

```bash
$ pip install robot-framework
```

Instale a biblioteca requests:

```bash
$ pip install robotframework-requests
```

Clone o repositório:

```bash
git clone https://github.com/personalnerd/cblab-api-robot.git
```

Navegue até o diretório do projeto:

```bash
cd cblab-api-robot
```

## Executando os Testes

Para executar os testes, utilize o seguinte comando:

```bash
robot -d results suites
```

Ou se tiver o Node e Npm instalados na máquina, pode utilizar o script:

```bash
npm run test
```

O relatório dos testes ficará armazenado na pasta `results/`

# Cenários de testes

## Cenários identificados para as rotas:

| Rota                                                       | Add cart                                                            |          |
| ---------------------------------------------------------- | ------------------------------------------------------------------- | -------- |
| **Cenário de teste**                                       | **Resultado esperado**                                              | **Tipo** |
| Criar carrinho para o usuário existente                    | Status 201: Carrinho criado                                         | Positivo |
| Criar carrinho para usuário inexistente                    | Erro 404: Usuário não encontrado                                    | Negativo |
| Criar carrinho sem enviar o usuário                        | Erro 400: User id é requerido                                       | Negativo |
| Criar carrinho sem enviar produtos                         | Erro 400: Produtos não podem estar vazios                           | Negativo |
| Criar carrinho com produto inexistente                     | Status 201: Carrinho vazio, o produto não é adicionado              | Positivo |
| Criar carrinho com produto inexistente + produto existente | Status 201: Carrinho criado apenas com o(s) produto(s) existente(s) | Positivo |
| Criar carrinho sem enviar a quantidade do produto          | Status 201: carrinho criado, produto com quantidade 1               | Positivo |
| Criar carrinho sem enviar o body                           | Erro 400: User id é requerido                                       | Negativo |
| Criar carrinho sem o token de autorização                  | Erro 401: Access Token é requerido                                  | Negativo |
| Criar carrinho com token expirado ou inválido              | Erro 401: token inválido/expirado                                   | Negativo |

| Rota                                                              | Update cart                                                  |          |
| ----------------------------------------------------------------- | ------------------------------------------------------------ | -------- |
| **Cenário de teste**                                              | **Resultado esperado**                                       | **Tipo** |
| Adicionar novo item no carrinho                                   | Status 200: Carrinho atualizado com o novo item              | Positivo |
| Remover um item do carrinho                                       | Status 200: carrinho atualizado, produto removido            | Positivo |
| Adicionar novo item em carrinho inexistente                       | Erro 404: Cart não encontrado                                | Negativo |
| Adicionar item inexistente em carrinho                            | Status 200: cart não atualizado                              | Positivo |
| Atualizar carrinho sem enviar produtos                            | Status 200: cart não atualizado                              | Positivo |
| Atualizar carrinho removendo os produtos                          | Status 200: cart atualizado, removidos todos os produtos     | Positivo |
| Atualizar carrinho enviando string texto na quantidade do produto | Status 200: carta atualizado, produto com quantidade 1       | Positivo |
| Atualizar carrinho sem enviar o body                              | Status 200: carrinho atualizado, removidos todos os produtos | Positivo |
| Atualizar carrinho sem o token de autorização                     | Erro 401: Access Token é requerido                           | Negativo |
| Atualizar carrinho com token expirado ou inválido                 | Erro 401: token inválido/expirado                            | Negativo |

| Rota                                            | Delete cart                                     |          |
| ----------------------------------------------- | ----------------------------------------------- | -------- |
| **Cenário de teste**                            | **Resultado esperado**                          | **Tipo** |
| Excluir carrinho                                | Status 200: carrinho excluído (isDeleted: true) | Positivo |
| Excluir carrinho inexistente                    | Erro 404: Cart não encontrado                   | Negativo |
| Excluir carrinho sem o token de autorização     | Erro 401: Access Token é requerido              | Negativo |
| Excluir carrinho com token expirado ou inválido | Erro 401: token inválido/expirado               | Negativo |

## Cenários de testes automatizados

### Suíte de Testes Add Cart

### TC001 - Criar carrinho para usuário existente

Testa a criação bem-sucedida de carrinho com produtos válidos para usuário com id válido

**Pré-condições:**

- Usuário com ID 1 existente na base de dados
- Produtos com ID 16 e 17 existentes na base de dados
- Bearer Token válido

**Etapas:**

1. Enviar uma solicitação POST para “https://dummyjson.com/auth/carts/add” com Bearer Token de autenticação válido nos Headers.
2. Enviar body:

```json
{
  "userId": 1,
  "products": [
    {
      "id": 16,
      "quantity": 10
    },
    {
      "id": 17,
      "quantity": 2
    }
  ]
}
```

3. Verificar se o código de status da resposta é 201 (Created).
4. Afirmar que os dados JSON retornados contêm as informações esperadas do carrinho (id do carrinho, lista de produtos com dados básicos (id, título, preço unitário, quantidade, preço total, porcentagem de desconto, preço com desconto, imagem), preço total do pedido, preço total com desconto, id do usuário (1), total de produtos (2), quantidade total de itens (12)).

**Resultados esperados:** Json com dados do carrinho retornados corretamente, conforme documentação do DummyJson.

### TC002 - Criar carrinho para usuário inexistente

Testa o comportamento da API para o envio de usuário inválido

**Pré-condições:**

- Usuário com ID 999 inexistente na base de dados
- Produtos com ID 16 e 17 existentes na base de dados
- Bearer Token válido

**Etapas:**

1. Enviar uma solicitação POST para “https://dummyjson.com/auth/carts/add” com Bearer Token de autenticação válido nos Headers.
2. Enviar body:

```json
{
  "userId": 999,
  "products": [
    {
      "id": 16,
      "quantity": 10
    },
    {
      "id": 17,
      "quantity": 2
    }
  ]
}
```

3. Verificar se o código de status da resposta é 404 (Not Found).
4. Afirmar que a mensagem de erro indica “User with id ‘999’ not found”

**Resultados esperados:** Resposta de erro apropriada para o envio de id de usuário inválido.

### TC003 - Criar carrinho sem enviar o usuário

Testa o comportamento da API ao não enviar o ID do usuário

**Pré-condições:**

- Produtos com ID 16 e 17 existentes na base de dados
- Bearer Token válido

**Etapas:**

1. Enviar uma solicitação POST para “https://dummyjson.com/auth/carts/add” com Bearer Token de autenticação válido nos Headers.
2. Enviar body:

```json
{
  "products": [
    {
      "id": 16,
      "quantity": 10
    },
    {
      "id": 17,
      "quantity": 2
    }
  ]
}
```

3. Verificar se o código de status da resposta é 400 (Bad Request).
4. Afirmar que a mensagem de erro indica “User id is required”

**Resultados esperados:** Resposta de erro apropriada para o não envio de id de usuário.

### TC004 - Criar carrinho sem enviar produtos

Testa o comportamento da API ao não enviar os produtos na requisição

**Pré-condições:**

- Usuário com ID 1 existente no banco de dados
- Bearer Token válido

**Etapas:**

1. Enviar uma solicitação POST para “https://dummyjson.com/auth/carts/add” com Bearer Token de autenticação válido nos Headers.
2. Enviar body:

```json
{
  "userId": 1,
  "products": []
}
```

3. Verificar se o código de status da resposta é 400 (Bad Request).
4. Afirmar que a mensagem de erro indica “products can not be empty”

**Resultados esperados:** Resposta de erro apropriada para o não envio de produtos.

### TC005 - Criar carrinho com produto inexistente

Testa o comportamento da API ao enviar ID de produto inexistente

**Pré-condições:**

- Usuário com ID 1 existente na base de dados
- Produto com ID 999 inexistente na base de dados
- Bearer Token válido

**Etapas:**

1. Enviar uma solicitação POST para “https://dummyjson.com/auth/carts/add” com Bearer Token de autenticação válido nos Headers.
2. Enviar body:

```json
{
  "userId": 1,
  "products": [
    {
      "id": 999,
      "quantity": 10
    }
  ]
}
```

3. Verificar se o código de status da resposta é 201 (Created).
4. Afirmar que foi criado um carrinho vazio (sem produtos)

**Resultados esperados:** Json com dados do carrinho retornados corretamente, mas com um array vazio no campo “produtcs” e somatória 0 nos totais de produtos e preços

### TC006 - Criar carrinho com produto inexistente + produto existente

Testa o comportamento da API ao enviar ID de produto inexistente junto a outros produtos

**Pré-condições:**

- Usuário com ID 1 existente na base de dados
- Produto com ID 16 existente na base de dados
- Produto com ID 999 inexistente na base de dados
- Bearer Token válido.

**Etapas:**

1. Enviar uma solicitação POST para “https://dummyjson.com/auth/carts/add” com Bearer Token de autenticação válido nos Headers.
2. Enviar body:

```json
{
  "userId": 1,
  "products": [
    {
      "id": 16,
      "quantity": 10
    },
    {
      "id": 999,
      "quantity": 5
    }
  ]
}
```

3. Verificar se o código de status da resposta é 201 (Created).
4. Afirmar que foi criado um carrinho apenas com o produto válido, ignorando o produto inválido.

**Resultados esperados:** Json com dados do carrinho retornados corretamente, mas somente com os dados do produto válido.

### TC007 - Criar carrinho sem enviar a quantidade do produto

Testa o comportamento da API ao enviar um produto sem informar a quantidade (ou enviar 0)

**Pré-condições:**

- Usuário com ID 1 existente na base de dados
- Produtos com ID 16 e 17 existentes na base de dados
- Bearer Token válido.

**Etapas:**

1. Enviar uma solicitação POST para “https://dummyjson.com/auth/carts/add” com Bearer Token de autenticação válido nos Headers.
2. Enviar body:

```json
{
  "userId": 1,
  "products": [
    {
      "id": 16,
      "quantity": 10
    },
    {
      "id": 17,
      "quantity": 0
    }
  ]
}
```

3. Verificar se o código de status da resposta é 201 (Created).
4. Afirmar que os dados JSON retornados contêm as informações esperadas do carrinho e o produto sem quantidade (ou quantidade 0) recebeu a quantidade 1 como padrão.

**Resultados esperados:** Json com dados do carrinho retornados corretamente. O produto sem quantidade recebe a quantidade 1 como padrão.

### TC008 - Criar carrinho sem enviar o body

Testa o comportamento da API ao não enviar o body na requisição

**Pré-condições:**

- Bearer Token válido.

**Etapas:**

1. Enviar uma solicitação POST para “https://dummyjson.com/auth/carts/add” com Bearer Token de autenticação válido nos Headers.
2. Não enviar body.
3. Verificar se o código de status da resposta é 400 (Bad Request).
4. Afirmar que a mensagem de erro indica “User id is required”

**Resultados esperados:** Resposta de erro apropriada para o não envio do body na requisição.

### TC009 - Criar carrinho sem o token de autorização

Testa o comportamento da API ao tentar enviar uma requisição sem estar devidamente autenticado.

**Pré-condições:**

- Usuário com ID 1 existente na base de dados
- Produtos com ID 16 e 17 existentes na base de dados

**Etapas:**

1. Enviar uma solicitação POST para “https://dummyjson.com/auth/carts/add” sem enviar Bearer Token de autenticação nos Headers.
2. Enviar body:

```json
{
  "userId": 1,
  "products": [
    {
      "id": 16,
      "quantity": 10
    },
    {
      "id": 17,
      "quantity": 5
    }
  ]
}
```

3. Verificar se o código de status da resposta é 401 (Unathorized).
4. Afirmar que a mensagem de erro indica “Access Token is required”.

**Resultados esperados:** Resposta de erro apropriada para o envio de requisição sem autenticação.

### TC010 - Criar carrinho com token expirado

Testa o comportamento da API ao tentar enviar uma requisição com o token de autenticação expirado.

**Pré-condições:**

- Usuário com ID 1 existente na base de dados
- Produtos com ID 16 e 17 existentes na base de dados
- Bearer Token expirado.

**Etapas:**

1. Enviar uma solicitação POST para “https://dummyjson.com/auth/carts/add” com Bearer Token de autenticação expirado nos Headers.
2. Enviar body:

```json
{
  "userId": 1,
  "products": [
    {
      "id": 16,
      "quantity": 10
    },
    {
      "id": 17,
      "quantity": 5
    }
  ]
}
```

3. Verificar se o código de status da resposta é 401 (Unathorized).
4. Afirmar que a mensagem de erro indica “Token Expired!”.

**Resultados esperados:** Resposta de erro apropriada para o envio de requisição com token de autenticação expirado.

### TC011 - Criar carrinho com token inválido

Testa o comportamento da API ao tentar enviar uma requisição com o token de autenticação inválido.

**Pré-condições:**

- Usuário com ID 1 existente na base de dados
- Produtos com ID 16 e 17 existentes na base de dados
- Bearer Token inválido.

**Etapas:**

1. Enviar uma solicitação POST para “https://dummyjson.com/auth/carts/add” com Bearer Token de autenticação inválido nos Headers.
2. Enviar body:

```json
{
  "userId": 1,
  "products": [
    {
      "id": 16,
      "quantity": 10
    },
    {
      "id": 17,
      "quantity": 5
    }
  ]
}
```

3. Verificar se o código de status da resposta é 401 (Unathorized).
4. Afirmar que a mensagem de erro indica “Invalid/Expired Token!”.

**Resultados esperados:** Resposta de erro apropriada para o envio de requisição com token de autenticação inválido.

### Suíte de Testes Update Cart

### TC012 - Adicionar novo item no carrinho

Testa a atualização bem-sucedida de carrinho, adicionando novos produtos a um carrinho existente

**Pré-condições:**

- Carrinho com ID 33, existente na base de dados (já tem 2 produtos com os IDs 105 e 49)
- Produto com ID 16 existente na base de dados
- Bearer Token válido

**Etapas:**

1. Enviar uma solicitação PUT para “https://dummyjson.com/auth/carts/33” com Bearer Token de autenticação válido nos Headers.
2. Enviar body:

```json
{
  "merge": true,
  "products": [
    {
      "id": 16,
      "quantity": 10
    }
  ]
}
```

3. Verificar se o código de status da resposta é 200 (OK).
4. Afirmar que os dados JSON retornados contêm as informações esperadas do carrinho existente, incluindo a adição do novo produto enviado.

**Resultados esperados:** Json com dados do carrinho retornados corretamente, incluindo a adição do novo produto enviado.

### TC013 - Remover um item do carrinho

Testa a atualização bem-sucedida de carrinho, removendo um produto de um carrinho existente

**Pré-condições:**

- Carrinho com ID 33, existente na base de dados (já tem 2 produtos com os IDs 105 e 49)
- Bearer Token válido

**Etapas:**

1. Enviar uma solicitação PUT para “https://dummyjson.com/auth/carts/33” com Bearer Token de autenticação válido nos Headers.
2. Enviar body:

```json
{
  "merge": false,
  "products": [
    {
      "id": 105,
      "quantity": 2
    }
  ]
}
```

3. Verificar se o código de status da resposta é 200 (OK).
4. Afirmar que os dados JSON retornados contêm as informações esperadas do carrinho existente, excluindo o item não enviado na requisição.

**Resultados esperados:** Json com dados do carrinho retornados corretamente, apenas com os itens enviados, excluindo o item não enviado na requisição.

**Notas:** Na API DummyJson, para adicionar um novo produto, basta enviar o novo produto e a informação merge: true, que vai juntar o novo produto com os produtos já existentes no carrinho.

Para remover um produto, é preciso enviar todos os produtos já existentes e não enviar o produto que se quer retirar, alterando o campo merge para “false”, indicando que essa atualização, vai excluir os produtos anteriores e adicionar somente os novos produtos presentes na requisição.

### TC014 - Adicionar novo item em carrinho inexistente

Testa o comportamento da API ao tentar adicionar um item a um carrinho inexistente.

**Pré-condições:**

- Carrinho com ID 999, inexistente na base de dados
- Produto com ID 16 existente na base de dados
- Bearer Token válido

**Etapas:**

1. Enviar uma solicitação PUT para “https://dummyjson.com/auth/carts/999” com Bearer Token de autenticação válido nos Headers.
2. Enviar body:

```json
{
  "merge": true,
  "products": [
    {
      "id": 16,
      "quantity": 10
    }
  ]
}
```

3. Verificar se o código de status da resposta é 404 (Not Found).
4. Afirmar que a mensagem de erro indica “Cart with id ‘999’ not found”.

**Resultados esperados:** Resposta de erro apropriada para o envio de requisição para carrinho inexistente.

### TC015 - Adicionar item inexistente em carrinho

Testa o comportamento da API ao tentar adicionar um item inexistente a um carrinho.

**Pré-condições:**

- Carrinho com ID 33, existente na base de dados (já tem 2 produtos com os IDs 105 e 49)
- Produto com ID 999 inexistente na base de dados
- Bearer Token válido

**Etapas:**

1. Enviar uma solicitação PUT para “https://dummyjson.com/auth/carts/33” com Bearer Token de autenticação válido nos Headers.
2. Enviar body:

```json
{
  "merge": true,
  "products": [
    {
      "id": 999,
      "quantity": 10
    }
  ]
}
```

3. Verificar se o código de status da resposta é 200 (OK).
4. Afirmar que os dados JSON retornados contêm as informações esperadas do carrinho existente, sem modificação dos itens existentes.

**Resultados esperados:** Json com dados do carrinho já existente retornados corretamente, sem adição de novo produto.

### TC016 - Atualizar carrinho sem enviar produtos

Testa o comportamento da API ao tentar atualizar o carrinho, sem enviar nenhum produto.

**Pré-condições:**

- Carrinho com ID 33, existente na base de dados (já tem 2 produtos com os IDs 105 e 49)
- Bearer Token válido

**Etapas:**

1. Enviar uma solicitação PUT para “https://dummyjson.com/auth/carts/33” com Bearer Token de autenticação válido nos Headers.
2. Enviar body:

```json
{
  "merge": true,
  "products": []
}
```

3. Verificar se o código de status da resposta é 200 (OK).
4. Afirmar que os dados JSON retornados contêm as informações esperadas do carrinho existente, sem modificação dos itens existentes.

**Resultados esperados:** Json com dados do carrinho já existente retornados corretamente, sem modificação dos itens existentes.

### TC017 - Atualizar carrinho removendo os produtos

Testa o comportamento da API ao tentar atualizar o carrinho, sem enviar nenhum produto e com o campo merge = false.

**Pré-condições:**

- Carrinho com ID 33, existente na base de dados (já tem 2 produtos com os IDs 105 e 49)
- Bearer Token válido

**Etapas:**

1. Enviar uma solicitação PUT para “https://dummyjson.com/auth/carts/33” com Bearer Token de autenticação válido nos Headers.
2. Enviar body:

```json
{
  "merge": false,
  "products": []
}
```

3. Verificar se o código de status da resposta é 200 (OK).
4. Afirmar que os dados JSON retornados contêm as informações esperadas do carrinho existente, mas vazio (sem produtos).

**Resultados esperados:** Json com dados do carrinho retornados corretamente, mas com um array vazio no campo “produtcs” e somatória 0 nos totais de produtos e preços

### TC018 - Atualizar carrinho enviando string texto na quantidade do produto

Testa a atualização bem-sucedida de carrinho, validando o comportamento da API ao adicionar um novo produto com um erro de tipo de dado no campo “quantidade”

**Pré-condições:**

- Carrinho com ID 33, existente na base de dados (já tem 2 produtos com os IDs 105 e 49)
- Produto com ID 16 existente na base de dados
- Bearer Token válido

**Etapas:**

1. Enviar uma solicitação PUT para “https://dummyjson.com/auth/carts/33” com Bearer Token de autenticação válido nos Headers.
2. Enviar body:

```json
{
    "merge": true,
    "products": [
        {
            "id": 16,
            "quantity": “cinco”
        }
    ]
}
```

3. Verificar se o código de status da resposta é 200 (OK).
4. Afirmar que os dados JSON retornados contêm as informações esperadas do carrinho existente, incluindo a adição do novo produto enviado, com a quantidade 1.

**Resultados esperados:** Json com dados do carrinho retornados corretamente, incluindo a adição do novo produto enviado. A API ignorou o valor do tipo string e adicionou a quantidade 1 no produto enviado.

### TC019 - Atualizar carrinho sem enviar o body

Testa o comportamento da API ao tentar atualizar o carrinho, sem enviar nada no body da requisição.

**Pré-condições:**

- Carrinho com ID 33, existente na base de dados (já tem 2 produtos com os IDs 105 e 49).
- Bearer Token válido.

**Etapas:**

1. Enviar uma solicitação PUT para “https://dummyjson.com/auth/carts/33” com Bearer Token de autenticação válido nos Headers.
2. Não enviar body
3. Verificar se o código de status da resposta é 200 (OK).
4. Afirmar que os dados JSON retornados contêm as informações esperadas do carrinho existente, mas vazio (sem produtos).

**Resultados esperados:** Json com dados do carrinho retornados corretamente, mas com um array vazio no campo “produtcs” e somatória 0 nos totais de produtos e preços

### TC020 - Atualizar carrinho sem o token de autorização

Testa o comportamento da API ao tentar enviar uma requisição sem estar devidamente autenticado.

**Pré-condições:**

- Carrinho com ID 33, existente na base de dados (já tem 2 produtos com os IDs 105 e 49)
- Produto com ID 16 existente na base de dados

**Etapas:**

1. Enviar uma solicitação PUT para “https://dummyjson.com/auth/carts/33” sem enviar Bearer Token de autenticação nos Headers.
2. Enviar body:

```json
{
  "merge": true,
  "products": [
    {
      "id": 16,
      "quantity": 10
    }
  ]
}
```

3. Verificar se o código de status da resposta é 401 (Unathorized).
4. Afirmar que a mensagem de erro indica “Access Token is required”.

**Resultados esperados:** Resposta de erro apropriada para o envio de requisição sem autenticação.

### TC021 - Atualizar carrinho com token expirado

Testa o comportamento da API ao tentar enviar uma requisição com o token de autenticação expirado.

**Pré-condições:**

- Carrinho com ID 33, existente na base de dados (já tem 2 produtos com os IDs 105 e 49).
- Produto com ID 16 existente na base de dados.
- Bearer Token expirado.

**Etapas:**

1. Enviar uma solicitação PUT para “https://dummyjson.com/auth/carts/33” com Bearer Token de autenticação expirado nos Headers.
2. Enviar body:

```json
{
  "merge": true,
  "products": [
    {
      "id": 16,
      "quantity": 10
    }
  ]
}
```

3. Verificar se o código de status da resposta é 401 (Unathorized).
4. Afirmar que a mensagem de erro indica “Token Expired!”.

**Resultados esperados:** Resposta de erro apropriada para o envio de requisição com token de autenticação expirado.

### TC022 - Atualizar carrinho com token inválido

Testa o comportamento da API ao tentar enviar uma requisição com o token de autenticação inválido.

**Pré-condições:**

- Carrinho com ID 33, existente na base de dados (já tem 2 produtos com os IDs 105 e 49).
- Produto com ID 16 existente na base de dados.
- Bearer Token inválido.

**Etapas:**

1. Enviar uma solicitação PUT para “https://dummyjson.com/auth/carts/33” com Bearer Token de autenticação inválido nos Headers.
2. Enviar body:

```json
{
  "merge": true,
  "products": [
    {
      "id": 16,
      "quantity": 10
    }
  ]
}
```

3. Verificar se o código de status da resposta é 401 (Unathorized).
4. Afirmar que a mensagem de erro indica “Invalid/Expired Token!”.

**Resultados esperados:** Resposta de erro apropriada para o envio de requisição com token de autenticação inválido.

### Suíte de Testes Delete Cart

### TC023 - Excluir carrinho

Testa a exclusão bem-sucedida de carrinho

**Pré-condições:**

- Carrinho com ID 33, existente na base de dados (já tem 2 produtos com os IDs 105 e 49)
- Bearer Token válido

**Etapas:**

1. Enviar uma solicitação DELETE para “https://dummyjson.com/auth/carts/33” com Bearer Token de autenticação válido nos Headers.
2. Verificar se o código de status da resposta é 200 (OK).
3. Afirmar que os dados JSON retornados contêm as informações esperadas do carrinho mais os campos “isDeleted” e “deletedOn”, indicando que o carrinho fora excluído.

**Resultados esperados:** Json com dados do carrinho retornados corretamente, conforme documentação do DummyJson mais as informações de exclusão do carrinho.

### TC024 - Excluir carrinho inexistente

Testa o comportamento da API ao enviar a requisição de exclusão de um carrinho inexistente

**Pré-condições:**

- Carrinho com ID 999, inexistente na base de dados
- Bearer Token válido

**Etapas:**

1. Enviar uma solicitação DELETE para “https://dummyjson.com/auth/carts/999” com Bearer Token de autenticação válido nos Headers.
2. Verificar se o código de status da resposta é 404 (Not Found).
3. Afirmar que a mensagem de erro indica “Cart with id ‘999’ not found”.

**Resultados esperados:** Resposta de erro apropriada para o envio de exclusão para carrinho inexistente.

### TC025 - Excluir carrinho sem o token de autorização

Testa o comportamento da API ao tentar enviar uma requisição sem estar devidamente autenticado.

**Pré-condições:**
Carrinho com ID 33, existente na base de dados (já tem 2 produtos com os IDs 105 e 49)

**Etapas:**

1. Enviar uma solicitação DELETE para “https://dummyjson.com/auth/carts/33” sem enviar Bearer Token de autenticação nos Headers.
2. Verificar se o código de status da resposta é 401 (Unathorized).
3. Afirmar que a mensagem de erro indica “Access Token is required”.

**Resultados esperados:** Resposta de erro apropriada para o envio de requisição sem autenticação.

### TC026 - Excluir carrinho com token expirado

Testa o comportamento da API ao tentar enviar uma requisição com o token de autenticação expirado.

**Pré-condições:**

- Carrinho com ID 33, existente na base de dados (já tem 2 produtos com os IDs 105 e 49).
- Bearer Token expirado.
  **Etapas:**

1. Enviar uma solicitação DELETE para “https://dummyjson.com/auth/carts/33” com Bearer Token de autenticação inválido nos Headers.
2. Verificar se o código de status da resposta é 401 (Unathorized).
3. Afirmar que a mensagem de erro indica “Token Expired!”.

**Resultados esperados:** Resposta de erro apropriada para o envio de requisição com token de autenticação expirado.

### TC027 - Excluir carrinho com token inválido

Testa o comportamento da API ao tentar enviar uma requisição com o token de autenticação inválido.

**Pré-condições:**

- Carrinho com ID 33, existente na base de dados (já tem 2 produtos com os IDs 105 e 49).
- Bearer Token inválido.

**Etapas:**

1. Enviar uma solicitação DELETE para “https://dummyjson.com/auth/carts/33” com Bearer Token de autenticação inválido nos Headers.
2. Verificar se o código de status da resposta é 401 (Unathorized).
3. Afirmar que a mensagem de erro indica “Invalid/Expired Token!”.

**Resultados esperados:** Resposta de erro apropriada para o envio de requisição com token de autenticação inválido.
