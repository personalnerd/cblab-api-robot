*** Settings ***
Resource        ../resources/main.robot

Suite Setup     Pegar token


*** Test Cases ***
TC001 - Criar carrinho para usuário existente
    [Documentation]    Testa a criação bem-sucedida de carrinho com produtos válidos para usuário com id válido
    ${response}    Adicionar dois novos produtos para usuário de id 1
    ...    prod1Id=16
    ...    prod1Quant=10
    ...    prod2Id=17
    ...    prod2Quant=5

    A requisição deve ser bem-sucedida com status 201    ${response}
    A requisição deve retornar o carrinho com 2 produtos    ${response}
    No carrinho devem constar 2 produtos 16 e 17 com as quantidades 10 e 5, respectivamente    ${response}
    No carrinho deve constar o ID do usuário 1    ${response}
    No carrinho deve constar o total de itens igual a 15    ${response}

TC002 - Criar carrinho para usuário inexistente
    [Documentation]    Testa o comportamento da API para o envio de usuário inválido
    ${response}    Adicionar dois novos produtos para usuário de id 999
    ...    prod1Id=16
    ...    prod1Quant=10
    ...    prod2Id=17
    ...    prod2Quant=5

    A requisição deve retornar um erro 404    ${response}
    A requisição deve retornar uma mensagem de erro de usuário não encontrado    ${response}

TC003 - Criar carrinho sem enviar o usuário
    [Documentation]    Testa o comportamento da API ao não enviar o ID do usuário
    ${response}    Adicionar dois novos produtos sem enviar o usuário
    ...    prod1Id=16
    ...    prod1Quant=10
    ...    prod2Id=17
    ...    prod2Quant=5

    A requisição deve retornar um erro 400    ${response}
    A requisição deve retornar uma mensagem de erro de que o id do usuário é necessário    ${response}

TC004 - Criar carrinho sem enviar produtos
    [Documentation]    Testa o comportamento da API ao não enviar os produtos na requisição
    ${response}    Criar um carrinho sem produtos para o usuário de id 1

    A requisição deve retornar um erro 400    ${response}
    A requisição deve retornar uma mensagem de erro que os produtos não podem estar vazios    ${response}

TC005 - Criar carrinho com produto inexistente
    [Documentation]    Testa o comportamento da API ao enviar ID de produto inexistente
    ${response}    Adicionar um produto inexistente para usuário de id 1
    ...    prod1Id=999
    ...    prod1Quant=10

    A requisição deve ser bem-sucedida com status 201    ${response}
    A requisição deve retornar o carrinho com 0 produtos    ${response}
    No carrinho deve constar o ID do usuário 1    ${response}
    No carrinho deve constar o total de itens igual a 0    ${response}

TC006 - Criar carrinho com produto inexistente + produto existente
    [Documentation]    Testa o comportamento da API ao enviar ID de produto inexistente junto a outros produtos
    ${response}    Adicionar dois novos produtos para usuário de id 1
    ...    prod1Id=16
    ...    prod1Quant=10
    ...    prod2Id=999
    ...    prod2Quant=5

    A requisição deve ser bem-sucedida com status 201    ${response}
    A requisição deve retornar o carrinho com 1 produto    ${response}
    No carrinho devem constar o produto 16 com a quantidade 10    ${response}
    No carrinho deve constar o ID do usuário 1    ${response}
    No carrinho deve constar o total de itens igual a 10    ${response}

TC007 - Criar carrinho sem enviar a quantidade do produto
    [Documentation]    Testa o comportamento da API ao enviar um produto sem informar a quantidade
    ${response}    Adicionar dois novos produtos para usuário de id 1
    ...    prod1Id=16
    ...    prod1Quant=10
    ...    prod2Id=17
    ...    prod2Quant=0

    A requisição deve ser bem-sucedida com status 201    ${response}
    A requisição deve retornar o carrinho com 2 produtos    ${response}
    No carrinho devem constar 2 produtos 16 e 17 com as quantidades 10 e 1, respectivamente    ${response}
    No carrinho deve constar o ID do usuário 1    ${response}
    No carrinho deve constar o total de itens igual a 11    ${response}

TC008 - Criar carrinho sem enviar o body
    [Documentation]    Testa o comportamento da API ao não enviar o body na requisição
    ${response}    Enviar uma requisição sem enviar o body

    A requisição deve retornar um erro 400    ${response}
    A requisição deve retornar uma mensagem de erro de que o id do usuário é necessário    ${response}

TC009 - Criar carrinho sem o token de autorização
    [Documentation]    Testa o comportamento da API ao tentar enviar uma requisição sem estar devidamente autenticado.
    ${response}    Adicionar dois novos produtos para usuário de id 1
    ...    prod1Id=16
    ...    prod1Quant=10
    ...    prod2Id=17
    ...    prod2Quant=5
    ...    useToken=${False}

    A requisição deve retornar um erro 401    ${response}
    A requisição deve retornar uma mensagem de erro de que o token é necessário    ${response}

TC010 - Criar carrinho com token expirado
    [Documentation]    Testa o comportamento da API ao tentar enviar uma requisição com o token de autenticação inválido.
    ${response}    Adicionar dois novos produtos para usuário de id 1
    ...    prod1Id=16
    ...    prod1Quant=10
    ...    prod2Id=17
    ...    prod2Quant=5
    ...    token=${geral.expiredToken}

    A requisição deve retornar um erro 401    ${response}
    A requisição deve retornar uma mensagem de erro de token expirado    ${response}

TC010 - Criar carrinho com token inválido
    [Documentation]    Testa o comportamento da API ao tentar enviar uma requisição com o token de autenticação inválido.
    ${response}    Adicionar dois novos produtos para usuário de id 1
    ...    prod1Id=16
    ...    prod1Quant=10
    ...    prod2Id=17
    ...    prod2Quant=5
    ...    token=${geral.invalidToken}

    A requisição deve retornar um erro 401    ${response}
    A requisição deve retornar uma mensagem de erro de token inválido    ${response}
