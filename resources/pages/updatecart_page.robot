*** Settings ***
Resource    ../main.robot
Library     OperatingSystem


*** Keywords ***
## Requisições

## Asserções
Adicionar ${prodQuant} unidades do produto de id ${prodId} no carrinho de id ${cartId}
    [Arguments]
    ...    ${merge}=${True}
    ...    ${token}=${None}
    ...    ${useToken}=${True}

    ${jsonString}=    Catenate
    ...    {
    ...    "merge": ${merge},
    ...    "products": [
    ...    {
    ...    "id": ${prodId},
    ...    "quantity": ${prodQuant}}]}

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

    ${response}=    PUT
    ...    url=${geral.HOST}/${rotas.UPDATE_CART}/${cartId}
    ...    headers=${headers}
    ...    json=${jsonData}    expected_status=any

    RETURN    ${response}

Manter o produto de id ${prodId} com ${prodQuant} itens no carrinho de id ${cartId}
    [Arguments]
    ...    ${merge}=${False}
    ...    ${token}=${None}
    ...    ${useToken}=${True}

    ${jsonString}=    Catenate
    ...    {
    ...    "merge": ${merge},
    ...    "products": [
    ...    {
    ...    "id": ${prodId},
    ...    "quantity": ${prodQuant}}]}

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

    ${response}=    PUT
    ...    url=${geral.HOST}/${rotas.UPDATE_CART}/${cartId}
    ...    headers=${headers}
    ...    json=${jsonData}    expected_status=any

    RETURN    ${response}

Atualizar o carrinho de id ${cartId} sem enviar novos produtos
    [Arguments]
    ...    ${merge}=${True}
    ...    ${token}=${None}
    ...    ${useToken}=${True}

    ${jsonString}=    Catenate
    ...    {
    ...    "merge": ${merge},
    ...    "products": []}

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

    ${response}=    PUT
    ...    url=${geral.HOST}/${rotas.UPDATE_CART}/${cartId}
    ...    headers=${headers}
    ...    json=${jsonData}    expected_status=any

    RETURN    ${response}

Atualizar o carrinho de id ${cartId} sem enviar o body
    [Arguments]
    ...    ${merge}=${True}
    ...    ${token}=${None}
    ...    ${useToken}=${True}

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

    ${response}=    PUT
    ...    url=${geral.HOST}/${rotas.UPDATE_CART}/${cartId}
    ...    headers=${headers}
    ...    expected_status=any

    RETURN    ${response}
