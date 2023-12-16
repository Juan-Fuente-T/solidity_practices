/*
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

import {Test, console2} from "lib/forge-std/src/Test.sol";
import {MiERC20Plantilla} from "../src/MiERC20Plantilla.sol";

contract MiERC20PlantillaTest is Test {
    MiERC20Plantilla public miERC20Plantilla;
    address alice;

    event Genesis(address indexed creator);
    event Mint(address indexed to, uint256 amount);
    event Burn(uint256 amount);

    function setUp() public {
        miERC20Plantilla = new MiERC20Plantilla();
        alice = makeAddr("alice");
    }

    function testmiERC20Plantillagenesis() public {
        assertEq(miERC20Plantilla.totalSupply(), 1000000 * 1e18);
        console2.log("BalanceOwner", miERC20Plantilla.balanceOf(address(this)));
        assertEq(miERC20Plantilla.balanceOf(address(this)), 1000000 * 1e18);
    }

    function testmiERC20Plantillamint() public {
        vm.startPrank(alice);
        miERC20Plantilla.mint(alice, 20 * 1e18);
        vm.expectRevert("Address can't be 0");
        miERC20Plantilla.mint(address(0), 20 * 1e18);
        vm.expectRevert("Amount is not enough");
        miERC20Plantilla.mint(alice, 0 * 1e18);
        console2.log("Balance alice", miERC20Plantilla.balanceOf(alice));
        assertEq(miERC20Plantilla.balanceOf(alice), 20 * 1e18);
    }

    function testmiERC20PlantillaEmitsMint() public {
        vm.startPrank(alice);
        //Chequear que los topics sean los mismos que los que tenga el evento
        vm.expectEmit();
        // El evento que se espera
        emit Mint(alice, 20 * 1e18);
        miERC20Plantilla.mint(alice, 20 * 1e18);
    }

    function testmiERC20Plantillaburn() public {
        vm.startPrank(alice);
        miERC20Plantilla.mint(alice, 20 * 1e18);
        console2.log("Balance alice antes", miERC20Plantilla.balanceOf(alice));
        assertEq(miERC20Plantilla.balanceOf(alice), 20 * 1e18);
        //vm.expectEmit(true, true);
        //emit miERC20Plantilla.Burn(alice, 10);
        miERC20Plantilla.burn(10 * 1e18);
        console2.log(
            "Balance alice despues",
            miERC20Plantilla.balanceOf(alice)
        );
        assertEq(miERC20Plantilla.balanceOf(alice), 10 * 1e18);
        vm.expectRevert("Amount is not enough");
        miERC20Plantilla.burn(0);
    }

    function testmiERC20PlantillaEmitsBurn() public {
        //FALLA
        vm.startPrank(alice);
        miERC20Plantilla.mint(alice, 20 * 1e18);
        vm.expectEmit();
        emit Burn(10);
        miERC20Plantilla.burn(10);
    }
}
