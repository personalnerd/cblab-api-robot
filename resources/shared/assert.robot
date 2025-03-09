*** Settings ***
Resource    ../main.robot
Library     OperatingSystem


*** Keywords ***
A requisição deve ser bem-sucedida com status ${status}
    [Arguments]    ${response}
    Request Should Be Successful    ${response}

A requisição deve retornar o carrinho com ${quantProd} produtos
    [Arguments]    ${response}
    ${arrayProducts}=    Get Length    ${response.json()['products']}
    Should Be Equal As Numbers    ${arrayProducts}    ${quantProd}
    Should Be Equal As Numbers    ${response.json()['totalProducts']}    ${quantProd}

A requisição deve retornar o carrinho com ${quantProd} produto
    [Arguments]    ${response}
    ${arrayProducts}=    Get Length    ${response.json()['products']}
    Should Be Equal As Numbers    ${arrayProducts}    ${quantProd}
    Should Be Equal As Numbers    ${response.json()['totalProducts']}    ${quantProd}

No carrinho devem constar 2 produtos ${prod1Id} e ${prod2Id} com as quantidades ${prod1Quant} e ${prod2Quant}, respectivamente
    [Arguments]    ${response}
    Should Be Equal As Numbers    ${response.json()['products'][0]['id']}    ${prod1Id}
    Should Be Equal As Numbers    ${response.json()['products'][0]['quantity']}    ${prod1Quant}
    Should Be Equal As Numbers    ${response.json()['products'][1]['id']}    ${prod2Id}
    Should Be Equal As Numbers    ${response.json()['products'][1]['quantity']}    ${prod2Quant}

No carrinho devem constar 3 produtos ${prod1Id}, ${prod2Id} e ${prod3Id} com as quantidades ${prod1Quant}, ${prod2Quant} e ${prod3Quant}, respectivamente
    [Arguments]    ${response}
    Should Be Equal As Numbers    ${response.json()['products'][0]['id']}    ${prod1Id}
    Should Be Equal As Numbers    ${response.json()['products'][0]['quantity']}    ${prod1Quant}
    Should Be Equal As Numbers    ${response.json()['products'][1]['id']}    ${prod2Id}
    Should Be Equal As Numbers    ${response.json()['products'][1]['quantity']}    ${prod2Quant}
    Should Be Equal As Numbers    ${response.json()['products'][2]['id']}    ${prod3Id}
    Should Be Equal As Numbers    ${response.json()['products'][2]['quantity']}    ${prod3Quant}

No carrinho devem constar o produto ${prod1Id} com a quantidade ${prod1Quant}
    [Arguments]    ${response}
    Should Be Equal As Numbers    ${response.json()['products'][0]['id']}    ${prod1Id}
    Should Be Equal As Numbers    ${response.json()['products'][0]['quantity']}    ${prod1Quant}

No carrinho deve constar o ID do usuário ${userId}
    [Arguments]    ${response}
    Should Be Equal As Numbers    ${response.json()['userId']}    ${userId}

No carrinho deve constar o total de itens igual a ${totalProd}
    [Arguments]    ${response}
    Should Be Equal As Numbers    ${response.json()['totalQuantity']}    ${totalProd}

A requisição deve retornar um erro ${status}
    [Arguments]    ${response}
    Status Should Be    ${status}    ${response}

A requisição deve retornar uma mensagem de erro de ${tipo} não encontrado
    [Arguments]    ${response}
    IF    "${tipo}"=="usuário"
        ${tipo}=    Set Variable    User
    ELSE IF    "${tipo}"=="carrinho"
        ${tipo}=    Set Variable    Cart
    END
    Should Be Equal As Strings    ${response.json()['message']}    ${tipo} with id '999' not found

A requisição deve retornar uma mensagem de erro de que o id do usuário é necessário
    [Arguments]    ${response}
    Should Be Equal As Strings    ${response.json()['message']}    User id is required

A requisição deve retornar uma mensagem de erro que os produtos não podem estar vazios
    [Arguments]    ${response}
    Should Be Equal As Strings    ${response.json()['message']}    products can not be empty

A requisição deve retornar uma mensagem de erro de que o token é necessário
    [Arguments]    ${response}
    Should Be Equal As Strings    ${response.json()['message']}    Access Token is required

A requisição deve retornar uma mensagem de erro de token expirado
    [Arguments]    ${response}
    Should Be Equal As Strings    ${response.json()['message']}    Token Expired!

A requisição deve retornar uma mensagem de erro de token inválido
    [Arguments]    ${response}
    Should Be Equal As Strings    ${response.json()['message']}    Invalid/Expired Token!

A requisição deve retornar o carrinho de id ${cartId} com a informação que foi excluído
    [Arguments]    ${response}
    Should Be Equal As Strings    ${response.json()['id']}    ${cartId}
    Should Be Equal As Strings    ${response.json()['isDeleted']}    ${True}
