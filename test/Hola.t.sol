// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console, console2} from "forge-std/Test.sol";
import {Hola} from "../src/Hola.sol";

contract HolaTest is Test {
    Hola public hola;

    function setUp() public {
        hola = new Hola();

    }

    function testHola() public {
        assertEq(hola.diHola(), "Hola");
        assertEq(hola.getCantidadHolas(), 1);
        console.log(hola.getCantidadHolas());
        console.log(hola.diHola());
    }
}
