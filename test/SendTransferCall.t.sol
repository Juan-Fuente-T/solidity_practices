// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console, console2} from "lib/forge-std/src/Test.sol";
import {
    PuedoRecibirPeroSoloEnLaFuncion,
    PuedoRecibirDineroEnTransferencias,
    PuedoRecibirDineroDondeSea,
    NoPuedoRecibirDinero,
    EnvioDinero
} from "../src/SendTransferCall.sol";

interface IPuedoRecibirPeroSoloEnLaFuncion {
    function quieroDinero() external payable;
}

contract SendTransferCallTest is Test {
    PuedoRecibirPeroSoloEnLaFuncion ejemploFuncionPayable;
    PuedoRecibirDineroEnTransferencias ejemploReceive;
    PuedoRecibirDineroDondeSea ejemploFallback;
    NoPuedoRecibirDinero ejemploNonPayable;
    EnvioDinero envioDinero;
    address alice;
    address bob;

    //string MAINNET_RPC_URL = 'https://eth-mainnet.g.alchemy.com/v2/x285eIv7gcffbvHwtnxjDVz6kIgwvuw3';
    //uint256 mainnetFork;

    function setUp() public {
        ejemploFuncionPayable = new  PuedoRecibirPeroSoloEnLaFuncion();
        ejemploReceive = new PuedoRecibirDineroEnTransferencias();
        ejemploFallback = new PuedoRecibirDineroDondeSea();
        ejemploNonPayable = new NoPuedoRecibirDinero();
        envioDinero = new EnvioDinero();
        startHoax(alice, 10 ether); //esto hace que las siguientes llamadas sean de alice ya con dinero
        bob = makeAddr("bob");
        vm.deal(address(envioDinero), 1000 ether);
        //deal(address(ejemploEnvio), alice, 1 ether);
        //console2.log(address(envioDinero).balance);
        assertEq(address(envioDinero).balance, 1000 ether);
        assertEq(alice.balance, 10 ether);
    }

    function testEjemploNonPayable() public {
        assertEq(ejemploNonPayable.hola(), "Hola");
        vm.expectRevert(abi.encodeWithSignature("ErrorEnviar()"));
        envioDinero.enviarConCall(payable(address(ejemploNonPayable)));
    }

    function testEjemploFallback() public {
        envioDinero.enviarConSend(payable(address(ejemploFallback)));
        assertEq(address(ejemploFallback).balance, 1 ether);
    }

    function testEjemploReceive() public {
        envioDinero.enviarConTransfer(payable(address(ejemploReceive)));
        assertEq(address(ejemploReceive).balance, 1 ether);
    }

    function testEjemploReceive2() public {
        envioDinero.enviarConSend(payable(address(ejemploReceive)));
        assertEq(address(ejemploReceive).balance, 1 ether);
    }

    function testEjemploFuncionPayable() public {
        IPuedoRecibirPeroSoloEnLaFuncion(address(ejemploFuncionPayable)).quieroDinero{value: 1 ether}();
        assertEq(address(ejemploFuncionPayable).balance, 1 ether);
    }
}
