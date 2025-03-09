*** Settings ***
Library     RequestsLibrary
### Data ###
Resource    data/geral.robot
Resource    data/registro.robot
### Shared ###
Resource    shared/setup_teardown.robot
Resource    shared/assert.robot
### Pages ###
Resource    pages/addcart_page.robot
Resource    pages/updatecart_page.robot
Resource    pages/deletecart_page.robot
