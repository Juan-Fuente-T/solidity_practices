// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console, console2} from "forge-std/Test.sol";
import {RegistroNombres} from "../src/RegistroNombres.sol";

contract RegistroNombresTest is Test {
    RegistroNombres public registroNombres;
    address alice;
    address bob;
     error  NombreNoDisponible();

    function setUp() public {
        registroNombres = new RegistroNombres();
        alice = makeAddr("alice");
        bob= makeAddr("bob");
        //vm.deal(alice, 10 ether);
        vm.startPrank(alice);
    }

    function testRegistroNombres() public {
        registroNombres.registrar("Soponcio");
        console.log(registroNombres.getNombre());
        vm.stopPrank;
        vm.startPrank(bob);
        registroNombres.registrar("Churiflusty");
        console.log(registroNombres.getNombre());
        vm.expectRevert("ERROR");
        registroNombres.registrar("Churifluston");
     }
}