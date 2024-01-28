// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;

import {Test, console, console2} from "lib/forge-std/src/Test.sol";
import {InteractuaDAI} from "../src/InteractuaDAI.sol";

interface IDAI {
    function name() external view returns (string memory);

    function totalSupply() external view returns (uint256);
}

contract InteractuaDAITest is Test {
    //InteractuaDAI public interactuaDAI;
    InteractuaDAI public dai;
    //IDAI dai;
    uint256 mainnetFork;
    string MAINNET_RPC_URL = vm.envString("MAINNET_RPC_URL");

    function setUp() public {
        vm.createSelectFork(MAINNET_RPC_URL);
        address interactuaDAI = 0x6B175474E89094C44Da98b954EedeAC495271d0F;
        //dai = IDAI(interactuaDAI);
        dai = new InteractuaDAI();
        //mainnetFork = vm.createFork(MAINNET_RPC_URL);
        //vm.selectFork(mainnetFork);
        //assertEq(vm.activeFork(), mainnetFork);
    }

    function testInteractuaDAIName() public {
        console2.log("DAIName", dai.consultaNombreDAI());
        assertEq("Dai Stablecoin", dai.consultaNombreDAI());
    }

    function testInteractuaDAISupply() public {
        assertGt(dai.consultaTotalSupply(), 100 * 1e18);
        console2.log("Supply", dai.consultaTotalSupply() / (1e18));
    }
}

/*El objetivo de estos ejercicio es interactuar con contratos externos. En el primer ejercicio,
deberás crear un fork de la red principal de Ethereum (mainnet). En el segundo, el fork
deberá ser de la red de test Sepolia.


1 . Crea un contrato llamado InteractuaDAI. Este contrato deberá:
    a. Tener un constructor que reciba la dirección del token DAI
(0x6b175474e89094c44da98b954eedeac495271d0f) por parámetro, y guardarlo en
una variable llamada token que deberá ser de tipo address.
    b. Tener una función llamada consultaNombreDAI() que devolverá un string. Esta función
llamará a la función name() del token DAI, y devolverá el valor que devuelva dicha
función.
Nota: A parte del contrato, deberás crear una interfaz IDAI que contenga la/s funcion/es
necesarias para poder realizar el ejercicio de forma correcta. El test de este contrato
deberá comprobar que la función consultaNombreDAI() devuelve el valor “Dai
Stablecoin”.

2 . Considera el siguiente contrato ContadorBlockcoder con dirección
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
