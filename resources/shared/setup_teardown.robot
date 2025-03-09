*** Settings ***
Resource    ../main.robot


*** Keywords ***
Pegar token
    [Documentation]    Pegar token válido para utilizar nas requisições da API.
    Create Session    api_session    ${geral.HOST}
    &{headers}    Create Dictionary    Content-Type=application/json
    &{body}    Create Dictionary    username=${login.userName}    password=${login.password}
    ${response}    POST On Session    api_session    ${rotas.GET_TOKEN}    headers=${headers}    json=${body}
    ${login.token}    Set Variable    ${response.json()["accessToken"]}
