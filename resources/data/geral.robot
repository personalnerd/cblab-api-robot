*** Settings ***
Resource    ../main.robot


*** Variables ***
&{geral}
...         HOST=https://dummyjson.com/auth
...         expiredToken=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwidXNlcm5hbWUiOiJlbWlseXMiLCJlbWFpbCI6ImVtaWx5LmpvaG5zb25AeC5kdW1teWpzb24uY29tIiwiZmlyc3ROYW1lIjoiRW1pbHkiLCJsYXN0TmFtZSI6IkpvaG5zb24iLCJnZW5kZXIiOiJmZW1hbGUiLCJpbWFnZSI6Imh0dHBzOi8vZHVtbXlqc29uLmNvbS9pY29uL2VtaWx5cy8xMjgiLCJpYXQiOjE3NDE0Nzg1MTcsImV4cCI6MTc0MTQ4MDMxN30.NTOBKnkEzx7fHpK1CnxjNl7mgbW6Y0E5k8qpzEQT3N8
...         invalidToken=123

# Rotas
&{rotas}
...         ADD_NEW_CART=carts/add
...         UPDATE_CART=carts
...         GET_TOKEN=login
