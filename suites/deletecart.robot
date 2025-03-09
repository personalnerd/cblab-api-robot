*** Settings ***
Resource        ../resources/main.robot

Suite Setup     Pegar token


*** Test Cases ***
TC023 - Excluir carrinho
    [Documentation]    Testa a exclusão bem-sucedida de carrinho
    ${response}    Exclui o carrinho de id 33

    A requisição deve ser bem-sucedida com status 200    ${response}
    A requisição deve retornar o carrinho de id 33 com a informação que foi excluído    ${response}

TC024 - Excluir carrinho inexistente
    [Documentation]    Testa o comportamento da API ao enviar a requisição de exclusão de um carrinho inexistente
    ${response}    Exclui o carrinho de id 999

    A requisição deve retornar um erro 404    ${response}
    A requisição deve retornar uma mensagem de erro de carrinho não encontrado    ${response}

TC025 - Excluir carrinho sem o token de autorização
    [Documentation]    Testa o comportamento da API ao tentar enviar uma requisição sem estar devidamente autenticado.
    ${response}    Exclui o carrinho de id 33    useToken=${False}

    A requisição deve retornar um erro 401    ${response}
    A requisição deve retornar uma mensagem de erro de que o token é necessário    ${response}

TC026 - Excluir carrinho com token expirado
    [Documentation]    Testa o comportamento da API ao tentar enviar uma requisição com o token de autenticação expirado.
    ${response}    Exclui o carrinho de id 33    token=${geral.expiredToken}

    A requisição deve retornar um erro 401    ${response}
    A requisição deve retornar uma mensagem de erro de token expirado    ${response}

TC027 - Excluir carrinho com token inválido
    [Documentation]    Testa o comportamento da API ao tentar enviar uma requisição com o token de autenticação inválido.
    ${response}    Exclui o carrinho de id 33    token=${geral.invalidToken}

    A requisição deve retornar um erro 401    ${response}
    A requisição deve retornar uma mensagem de erro de token inválido    ${response}
