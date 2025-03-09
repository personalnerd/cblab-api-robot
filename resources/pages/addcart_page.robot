*** Settings ***
Resource    ../main.robot
Library     OperatingSystem


*** Keywords ***
## Requisições
Adicionar dois novos produtos para usuário de id ${userId}
    [Arguments]
    ...    ${prod1Id}
    ...    ${prod1Quant}
    ...    ${prod2Id}
    ...    ${prod2Quant}
    ...    ${token}=${None}
    ...    ${useToken}=${True}

    ${jsonString}=    Catenate
    ...    {
    ...    "userId": ${userId},
    ...    "products": [
    ...    {
    ...    "id": ${prod1Id},
    ...    "quantity": ${prod1Quant}
    ...    },
    ...    {
    ...    "id": ${prod2Id},
    ...    "quantity": ${prod2Quant}
    ...    }
    ...    ]
    ...    }

    ${keywordToken}=    Set Variable    ${None}
    IF    ${{$token is None}}
        ${keywordToken}=    Set Variable    ${login.token}
    ELSE
        ${keywordToken}=    Set Variable    ${token}
    END

    IF    ${useToken}
        &{headers}=    Create Dictionary    Content-Type=application/json    Authorization=Bearer ${keywordToken}
    ELSE
        &{headers}=    Create Dictionary    Content-Type=application/json
    END
    ${jsonData}=    Evaluate    ${jsonString}

    ${response}=    POST
    ...    url=${geral.HOST}/${rotas.ADD_NEW_CART}
    ...    headers=${headers}
    ...    json=${jsonData}    expected_status=any

    RETURN    ${response}

Adicionar dois novos produtos sem enviar o usuário
    [Arguments]    ${prod1Id}    ${prod1Quant}    ${prod2Id}    ${prod2Quant}

    ${jsonString}=    Catenate
    ...    {
    ...    "products": [
    ...    {
    ...    "id": ${prod1Id},
    ...    "quantity": ${prod1Quant}
    ...    },
    ...    {
    ...    "id": ${prod2Id},
    ...    "quantity": ${prod2Quant}
    ...    }
    ...    ]
    ...    }

    &{headers}=    Create Dictionary    Content-Type=application/json    Authorization=Bearer ${login.token}
    ${jsonData}=    Evaluate    ${jsonString}

    ${response}=    POST
    ...    url=${geral.HOST}/${rotas.ADD_NEW_CART}
    ...    headers=${headers}
    ...    json=${jsonData}    expected_status=400

    RETURN    ${response}

Criar um carrinho sem produtos para o usuário de id ${userId}
    ${jsonString}=    Catenate
    ...    {
    ...    "userId": ${userId},
    ...    "products": []
    ...    }

    &{headers}=    Create Dictionary    Content-Type=application/json    Authorization=Bearer ${login.token}
    ${jsonData}=    Evaluate    ${jsonString}

    ${response}=    POST
    ...    url=${geral.HOST}/${rotas.ADD_NEW_CART}
    ...    headers=${headers}
    ...    json=${jsonData}    expected_status=400

    RETURN    ${response}

Adicionar um produto inexistente para usuário de id ${userId}
    [Arguments]    ${prod1Id}    ${prod1Quant}

    ${jsonString}=    Catenate
    ...    {
    ...    "userId": ${userId},
    ...    "products": [
    ...    {
    ...    "id": ${prod1Id},
    ...    "quantity": ${prod1Quant}
    ...    }
    ...    ]
    ...    }

    &{headers}=    Create Dictionary    Content-Type=application/json    Authorization=Bearer ${login.token}
    ${jsonData}=    Evaluate    ${jsonString}

    ${response}=    POST
    ...    url=${geral.HOST}/${rotas.ADD_NEW_CART}
    ...    headers=${headers}
    ...    json=${jsonData}    expected_status=any

    RETURN    ${response}

Enviar uma requisição sem enviar o body
    &{headers}=    Create Dictionary    Content-Type=application/json    Authorization=Bearer ${login.token}

    ${response}=    POST
    ...    url=${geral.HOST}/${rotas.ADD_NEW_CART}
    ...    headers=${headers}
    ...    expected_status=400

    RETURN    ${response}

Enviar uma requisição faltando uma vírgula no body
    [Arguments]    ${userId}    ${prod1Id}    ${prod1Quant}    ${prod2Id}    ${prod2Quant}

    ${jsonString}=    Catenate
    ...    {
    ...    "userId": ${userId}
    ...    "products": [
    ...    {
    ...    "id": ${prod1Id},
    ...    "quantity": ${prod1Quant}
    ...    },
    ...    {
    ...    "id": ${prod2Id},
    ...    "quantity": ${prod2Quant}
    ...    }
    ...    ]
    ...    }

    &{headers}=    Create Dictionary    Content-Type=application/json    Authorization=Bearer ${login.token}
    ${jsonData}=    Evaluate    ${jsonString}

    ${response}=    POST
    ...    url=${geral.HOST}/${rotas.ADD_NEW_CART}
    ...    headers=${headers}
    ...    json=${jsonData}    expected_status=400

    RETURN    ${response}
