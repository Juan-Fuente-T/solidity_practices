// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;
//import {console} from "forge-std/console.sol";

import {console} from "forge-std/console.sol";

//import {console} from "../lib/forge-std/src/console.sol";

/**
 . El primer ejercicio consistirá en crear un proxy propio, sin utilizar ninguna plantilla ni
patrones pre establecidos. Observaremos cómo gracias a los proxies podemos redirigir las
llamadas a una nueva implementación. El ejercicio constará de tres contratos:

a. Un contrato llamado Proxy. Este contrato deberá tener:
i. Una variable implementación: esta variable será la dirección a la cual redirigiremos
las llamadas del proxy. Inicialmente, deberá apuntar al contrato
ImplementaciónV1.
ii. Una variable owner: será el dueño del contrato
iii. Una función upgrade() que recibirá la dirección de la nueva implementación a la
que apuntará el proxy (considera qué restricciones pueden ser importantes para
esta función)
iv. Una función de fallback que rediriga todas las llamadas a la implementación
utilizando delegatecall
b. Un contracto llamado ImplementaciónV1 (hecho por nosotros, lo podéis encontrar en
el fichero CalculatorV1.sol). Este contrato consiste en una implementación incorrecta
de una calculadora.
c. Un contrato llamado ImplementaciónV2. Este contrato consistirá en arreglar la
calculadora para que funcione de forma correcta

El objetivo de este ejercicio es arreglar el contrato de calculadora incorrecto
(ImplementaciónV1), para que el proxy pueda operar con normalidad. Tu test deberá hacer
deploy del proxy apuntando inicialmente a la ImplementaciónV1. A continuación, deberás
ejecutar el upgrade hacia la ImplementaciónV2. Deberás comprobar que llamar al proxy con
las funciones addition(), substraction(), multiplication() y division() devuelve resultados
correctos debido a que el proxy redirige a ImplementaciónV2 en vez de ImplementaciónV1.
 */

contract Proxy {
    address public implementation;
    address owner;

    error NotOwner();

    modifier onlyOwner() {
        if (msg.sender != owner) {
            revert NotOwner();
        }
        _;
    }

    constructor(address _implementation) {
        owner = msg.sender;
        implementation = _implementation;
    }

    //console.log("AddressImplementacion");
    function upgrade(address new_implementation) public onlyOwner {
        implementation = new_implementation;
    }

    fallback() external payable {
        require(implementation != address(0), "Implementation address not set");
        (bool success, bytes memory data) = implementation.delegatecall(
            msg.data
        );
        require(success, "Delegatecall failed");
        assembly {
            return(add(data, 0x20), mload(data))
        }
    }

    /*fallback() external payable {
        console.logAddress(owner);
        console.log("Fallback called");
        console.logAddress(implementation);
        console.logBytes(msg.data);
        require(implementation != address(0), "Implementation address not set");
        (bool success, bytes memory data) = implementation.delegatecall(
            msg.data
        );
        require(success, "Delegatecall failed");
        console.log("Delegatecall succeeded", success);
    }*/
}
