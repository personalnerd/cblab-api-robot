*** Settings ***
Resource    ../main.robot
Library     OperatingSystem


*** Keywords ***
## Requisições

## Asserções
Exclui o carrinho de id ${cartId}
    [Arguments]
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

    ${response}=    DELETE
    ...    url=${geral.HOST}/${rotas.UPDATE_CART}/${cartId}
    ...    headers=${headers}
    ...    expected_status=any

    RETURN    ${response}
