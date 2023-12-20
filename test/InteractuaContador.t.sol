// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.21;

import {Test, console, console2} from "lib/forge-std/src/Test.sol";
import {InteractuaContador} from "../src/InteractuaContador.sol";

interface IContadorBlockcoder {
    function increment() external;

    function decrement() external;

    function counter() external view returns (uint256);
}

contract InteractuaContadorTest is Test {
    InteractuaContador public interactuaContador;
    uint256 sepoliaFork;
    string SEPOLIA_RPC_URL = vm.envString("SEPOLIA_RPC_URL");

    //event Deposited(address indexed depositor, uint256 indexed amount);
    //event Withdraw(address indexed withdrawer, uint256 indexed amount);

    function setUp() public {
        interactuaContador = new InteractuaContador();

        //sepoliaFork = vm.createFork(SEPOLIA_RPC_URL);
        //vm.selectFork(sepoliaFork);
        vm.createSelectFork(SEPOLIA_RPC_URL);
        assertEq(vm.activeFork(), sepoliaFork);
    }

    function testIncrementaContador() public {
        assertEq(interactuaContador.consultaContador(), 0);
        interactuaContador.incrementaContador();
        assertEq(interactuaContador.consultaContador(), 1);
    }

    function testDecrementaContador() public {
        assertEq(interactuaContador.consultaContador(), 0);
        interactuaContador.incrementaContador();
        assertEq(interactuaContador.consultaContador(), 1);
        interactuaContador.incrementaContador();
        interactuaContador.decrementaContador();
        assertEq(interactuaContador.consultaContador(), 1);
    }
}
