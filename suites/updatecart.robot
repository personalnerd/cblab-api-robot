*** Settings ***
Resource        ../resources/main.robot

Suite Setup     Pegar token


*** Test Cases ***
TC012 - Adicionar novo item no carrinho
    [Documentation]    Testa a atualização bem-sucedida de carrinho, adicionando novos produtos a um carrinho existente
    ${response}    Adicionar 10 unidades do produto de id 16 no carrinho de id 33

    A requisição deve ser bem-sucedida com status 201    ${response}
    A requisição deve retornar o carrinho com 3 produtos    ${response}
    No carrinho devem constar 3 produtos 105, 49 e 16 com as quantidades 2, 5 e 10, respectivamente    ${response}
    No carrinho deve constar o total de itens igual a 17    ${response}

TC013 - Remover um item do carrinho
    [Documentation]    Testa a atualização bem-sucedida de carrinho, removendo um produto de um carrinho existente
    ${response}    Manter o produto de id 105 com 2 itens no carrinho de id 33

    A requisição deve ser bem-sucedida com status 201    ${response}
    A requisição deve retornar o carrinho com 1 produto    ${response}
    No carrinho devem constar o produto 105 com a quantidade 2    ${response}
    No carrinho deve constar o total de itens igual a 2    ${response}

TC014 - Adicionar novo item em carrinho inexistente
    [Documentation]    Testa o comportamento da API ao tentar adicionar um item a um carrinho inexistente.
    ${response}    Adicionar 10 unidades do produto de id 16 no carrinho de id 999

    A requisição deve retornar um erro 404    ${response}
    A requisição deve retornar uma mensagem de erro de carrinho não encontrado    ${response}

TC015 - Adicionar item inexistente em carrinho
    [Documentation]    Testa o comportamento da API ao tentar adicionar um item inexistente a um carrinho.
    ${response}    Adicionar 10 unidades do produto de id 999 no carrinho de id 33

    A requisição deve ser bem-sucedida com status 201    ${response}
    A requisição deve retornar o carrinho com 2 produtos    ${response}
    No carrinho devem constar 2 produtos 105 e 49 com as quantidades 2 e 5, respectivamente    ${response}
    No carrinho deve constar o total de itens igual a 7    ${response}

TC016 - Atualizar carrinho sem enviar produtos
    [Documentation]    Testa o comportamento da API ao tentar atualizar o carrinho, sem enviar nenhum produto.
    ${response}    Atualizar o carrinho de id 33 sem enviar novos produtos

    A requisição deve ser bem-sucedida com status 201    ${response}
    A requisição deve retornar o carrinho com 2 produtos    ${response}
    No carrinho devem constar 2 produtos 105 e 49 com as quantidades 2 e 5, respectivamente    ${response}
    No carrinho deve constar o total de itens igual a 7    ${response}

TC017 - Atualizar carrinho removendo os produtos
    [Documentation]    Testa o comportamento da API ao tentar atualizar o carrinho, sem enviar nenhum produto e com o campo merge = false.
    ${response}    Atualizar o carrinho de id 33 sem enviar novos produtos    merge=${False}

    A requisição deve ser bem-sucedida com status 201    ${response}
    A requisição deve retornar o carrinho com 0 produtos    ${response}
    No carrinho deve constar o total de itens igual a 0    ${response}

TC018 - Atualizar carrinho enviando string texto na quantidade do produto
    [Documentation]    Testa a atualização bem-sucedida de carrinho, validando o comportamento da API ao adicionar um novo produto com um erro de tipo de dado no campo “quantidade”
    ${response}    Adicionar "dez" unidades do produto de id 16 no carrinho de id 33

    A requisição deve ser bem-sucedida com status 201    ${response}
    A requisição deve retornar o carrinho com 3 produtos    ${response}
    No carrinho devem constar 3 produtos 105, 49 e 16 com as quantidades 2, 5 e 1, respectivamente    ${response}
    No carrinho deve constar o total de itens igual a 8    ${response}

TC019 - Atualizar carrinho sem enviar o body
    [Documentation]    Testa o comportamento da API ao tentar atualizar o carrinho, sem enviar nada no body da requisição.
    ${response}    Atualizar o carrinho de id 33 sem enviar o body

    A requisição deve ser bem-sucedida com status 201    ${response}
    A requisição deve retornar o carrinho com 0 produtos    ${response}
    No carrinho deve constar o total de itens igual a 0    ${response}

TC020 - Atualizar carrinho sem o token de autorização
    [Documentation]    Testa o comportamento da API ao tentar enviar uma requisição sem estar devidamente autenticado.
    ${response}    Adicionar 10 unidades do produto de id 16 no carrinho de id 33    useToken=${False}

    A requisição deve retornar um erro 401    ${response}
    A requisição deve retornar uma mensagem de erro de que o token é necessário    ${response}

TC021 - Atualizar carrinho com token expirado
    [Documentation]    Testa o comportamento da API ao tentar enviar uma requisição com o token de autenticação expirado.
    ${response}    Adicionar 10 unidades do produto de id 16 no carrinho de id 33    token=${geral.expiredToken}

    A requisição deve retornar um erro 401    ${response}
    A requisição deve retornar uma mensagem de erro de token expirado    ${response}

TC022 - Atualizar carrinho com token inválido
    [Documentation]    Testa o comportamento da API ao tentar enviar uma requisição com o token de autenticação inválido.
    ${response}    Adicionar 10 unidades do produto de id 16 no carrinho de id 33    token=${geral.invalidToken}

    A requisição deve retornar um erro 401    ${response}
    A requisição deve retornar uma mensagem de erro de token inválido    ${response}
