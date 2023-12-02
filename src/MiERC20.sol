/*
Ejercicios Solidity - ERC20
Codingheroes
1. Token ERC20: Crea un token ERC20 utilizando una plantilla (puedes utilizar tanto la
plantilla de OpenZeppelin como la de Solmate):
a. Puedes darle el nombre y símbolo que más te guste!
b. El token deberá mintear 1 millón de tokens al creador del contrato (msg.sender)
cuando tu contrato sea deployado, y emitir un evento llamado Genesis, con la
dirección del creador como parámetro
c. Tu contrato deberá incluir una función pública llamada mint(address to, uint256
amount), que permita mintear una cantidad amount a una dirección to pasadas por
parámetro (la dirección to no podrá ser address(0), y la cantidad amount no podrá ser
0), y otra función pública llamada burn(uint256 amount), que permita quemar una
cantidad amount de la dirección que llame a la función burn() (la cantidad amount no
podrá ser 0). Ambas funciones deberán emitir un evento Mint(address to, uint256
amount) y Burn(uint256 amount) respectivamente.
d. Deberás crear los siguientes tests:
i. testDeploy(): test que permitirá comprobar que después de hacer el deployment la
el creador del contrato efectivamente ha recibido 1 millón de tokens
ii. testMint(): test que permitirá comprobar que al llamar la función pública mint() la
dirección to recibe correctamente la cantidad de tokens amount. También deberá
comprobar que al pasar una dirección 0 o una cantidad de tokens 0, el contrato
lanza un error
iii. testBurn(): test que permitirá comprobar que al llamar la función pública burn() los
tokens de la dirección to son quemados correctamente con la cantidad de tokens
amount. También deberá comprobar que al pasar una cantidad de tokens 0, el
contrato lanza un error
iv. Todos los tests deberán comprobar que los eventos de las funciones se emiten
correctamente utilizando expectEmit(
*/
// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import {ERC20} from "lib/forge-std/src/ERC20.sol";

contract MiERC20 is ERC20("MiERC20", "ME20", 18){
    address creator;

    event Genesis(address indexed creator);
    event Mint(address indexed to, uint256 amount);
    event Burn(uint256 amount);

    constructor(){
        creator = msg.sender;
        _mint(creator, 1000000);
        emit Genesis(creator);
       
    }

    function mint(address to, uint256 amount) public {
        require(to != address(0), "Address can't be 0");
        require(amount > 0, "Amount is not enougt");
        _mint(to, amount);
        emit Mint(to, amount);

    }
    function burn(address from, uint256 amount) public {
        require(amount > 0, "Amount is not enougt");
        _burn(from, amount);
        emit Burn(amount);
    }
}