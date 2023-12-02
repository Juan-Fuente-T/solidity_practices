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
import {MiERC20} from "../src/MiERC20.sol";

contract MiERC20Test is Test {
    MiERC20 public miERC20;
    address alice;
    event Genesis(address indexed creator);
    event Mint(address indexed to, uint256 amount);
    event Burn(uint256 amount);

    function setUp() public {
        miERC20 = new MiERC20();
        alice = makeAddr("alice");
    }

    function testMiERC20mint() public {
        assertEq(miERC20.totalSupply(), 1000000);
        console2.log("BalanceOwner", miERC20.balanceOf(address(this)));
        assertEq(miERC20.balanceOf(address(this)),1000000);
        vm.startPrank(alice);
        miERC20.mint(alice, 20);
        vm.expectRevert("Address can't be 0");
        miERC20.mint(address(0), 20);
        vm.expectRevert("Amount is not enougt");
        miERC20.mint(alice, 0);
        console2.log("Balance alice", miERC20.balanceOf(alice));
        assertEq(miERC20.balanceOf(alice), 20);
    }

    function testMiERC20EmitsMint() public{ //FALLA
       vm.startPrank(alice);
       // Call the mint function of the contract
       miERC20.mint(alice, 20);

      // Check that the topics 1 and the data are the same as the following emitted event
      vm.expectEmit(true, false, false, true);

      // The event we expect
      emit Mint(alice, 20);
    }
    
    function testMiERC20burn() public {
        vm.startPrank(alice);
        miERC20.mint(alice, 20);
        console2.log("Balance alice antes", miERC20.balanceOf(alice));
        assertEq(miERC20.balanceOf(alice), 20);
        //vm.expectEmit(true, true, true, false);
        //emit miERC20.Burn(alice, 10);
        miERC20.burn(alice, 10);
        console2.log("Balance alice despues", miERC20.balanceOf(alice));
        assertEq(miERC20.balanceOf(alice), 10);
        vm.expectRevert("Amount is not enougt");
        miERC20.burn(alice, 0);
    }
    function testMiERC20EmitsBurn()public{//FALLA
        vm.expectEmit();
        //emit miERC20.Burn(alice, 20);
        miERC20.burn(alice, 10);
    }
}