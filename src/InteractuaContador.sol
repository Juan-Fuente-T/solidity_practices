/*2 . Considera el siguiente contrato ContadorBlockcoder con dirección
0xe29686E156E52c429D47d44653316563e2708076, deployeado en la testnet de Sepolia
(https://sepolia.etherscan.io/address/0xe29686E156E52c429D47d44653316563e2708076).
Este contrato es muy simple: contiene una variable llamada counter que podemos
incrementar llamando a increment() y decrementar llamando a decrement(). Para realizar el
ejercicio, debes:
Ejercicios Solidity -
Interfaces
Codingheroes

    1. Crear un fichero llamado InteractuaContador.sol. Este fichero contendrá:
        i. La interfaz completa del contrato ContadorBlockcoder deployeado en sepolia
            (llámala como quieras, pero recuerda la norma sobre los nombres de interfaces
            comentada en clase!)
        ii. Un contrato llamado InteractuaContador, que tendrá:
            a. Una función llamada incrementaContador(). Esta función deberá llamar a la
            función increment() del contrato de sepolia ContadorBlockcoder
            b. Una función llamada decrementaContador(). Esta función deberá llamar a la
            función decrement() del contrato de sepolia ContadorBlockcoder
            c. Una función de lectura llamada consultaContador(). Esta función deberá
            llamar a la función counter() del contrato de sepolia ContadorBlockcoder
            para leer el valor del contador
    2. Testear la funcionalidad completa de tu contrato InteractuaContador.sol*/

// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.20;

import {console} from "lib/forge-std/src/Test.sol";

interface IContadorBlockcoder {
    function increment() external;

    function decrement() external;

    function counter() external view returns (uint256);
}

contract InteractuaContador {
    /*IContadorBlockcoder public contadorBlockcoder =
        IContadorBlockcoder(
            address(0xe29686E156E52c429D47d44653316563e2708076)
        );*/
    IContadorBlockcoder public contadorBlockcoder;

    constructor(address _contadorBlockcoder) {
        contadorBlockcoder = IContadorBlockcoder(_contadorBlockcoder);
        console.log("_contadorBlockcoder");
        console.log(_contadorBlockcoder);
        console.log("contadorBlockcoder");
        console.logAddress(address(contadorBlockcoder));
    }

    function incrementaContador() public {
        console.log("Incrementando contador");
        console.logAddress(address(contadorBlockcoder));
        contadorBlockcoder.increment();
    }

    function decrementaContador() public {
        console.log("Decrementando contador");
        console.logAddress(address(contadorBlockcoder));
        contadorBlockcoder.decrement();
    }

    function consultaContador() public view returns (uint256) {
        console.log("Consultando contador");
        console.logAddress(address(contadorBlockcoder));
        return contadorBlockcoder.counter();
    }
}
