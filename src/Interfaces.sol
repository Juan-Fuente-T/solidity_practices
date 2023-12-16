// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "lib/forge-std/src/Test.sol";

import "./Interface.sol";

contract TestInterfaz is Test {
    address public AAVE_POOL = 0x87870Bca3F3fD6335C3F4ce8392D69350B4fA4E2; // hacer un cast
    string MAINNET_RPC_URL = vm.envString("MAINNET_RPC_URL");

    function setUp() public {
        vm.createSelectFork(MAINNET_RPC_URL);
    }

    function testAAVE() public view {
        // Devuelve la direccion del addresses provider guardado en la pool
        address direccion = IPool(AAVE_POOL).ADDRESSES_PROVIDER();
        console.log("La direccion es:", direccion);
    }
}
