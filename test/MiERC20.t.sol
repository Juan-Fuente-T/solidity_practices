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
pragma solidity ^0.8.21;

import {ERC20} from "lib/forge-std/src/ERC20.sol";

import {Test, console2} from "lib/forge-std/src/Test.sol";
import {MiERC20} from "../src/MiERC20.sol";

contract MiERC20Test is Test {
    MiERC20 public miERC20;
    address alice;
    address bob;
    address carol;

    event Genesis(address indexed creator);
    event Mint(address indexed to, uint256 amount);
    event Burn(uint256 amount);
    event Transfer(address indexed from, address indexed to, uint256 amount);
    event TransferFrom(address indexed from, address indexed to, uint256 amount);
    event Approval(address indexed sender, address indexed approved, uint256 amount);

    function setUp() public {
        miERC20 = new MiERC20("MiERC20", "MERC20", 18);
        alice = makeAddr("alice");
        bob = makeAddr("bob");
        carol = makeAddr("carol");
    }

    function testMiERC20Genesis() public {
        assertEq(miERC20.creator(), 0x7FA9385bE102ac3EAc297483Dd6233D62b3e1496);
        vm.expectEmit();
        emit Genesis(0x7FA9385bE102ac3EAc297483Dd6233D62b3e1496);
        assertEq(miERC20.name(), "MiERC20");
        assertEq(miERC20.symbol(), "MERC20");
        assertEq(miERC20.decimals(), 18);
        assertEq(miERC20.balanceOf(address(this)), 1000000 * 1e18);
        assertEq(miERC20.totalSupply(), 1000000 * 1e18);
        console2.log("BalanceOwner", miERC20.balanceOf(address(this)));
    }

    function testMiERC20Transfer() public {
        vm.startPrank(alice);
        deal(address(miERC20), alice, 100 ether);
        assertEq(miERC20.balanceOf(alice), 100 ether);
        console2.log("BalanceAntes", miERC20.balanceOf(alice));
        miERC20.transfer(bob, 5 ether);
        console2.log("BalanceDespues", miERC20.balanceOf(alice));
        assertEq(miERC20.balanceOf(alice), 95 * 1e18);
        assertEq(miERC20.balanceOf(bob), 5 * 1e18);
        vm.expectRevert("Error en transferencia");
        miERC20.transfer(bob, 0 ether);
        vm.expectRevert("La direccion de destino no puede ser 0");
        miERC20.transfer(address(0x0), 1 ether);
        vm.expectRevert("Error en transferencia");
        miERC20.transfer(bob, 99 ether);
    }

    function testMiERC20EmitsTransfer() public {
        vm.startPrank(alice);
        deal(address(miERC20), alice, 100 ether);
        vm.expectEmit();
        emit Transfer(alice, bob, 5 ether);
        miERC20.transfer(bob, 5 ether);
    }

    function testMiERC20Approve() public {
        vm.startPrank(alice);
        deal(address(miERC20), alice, 100 ether);
        miERC20.approve(bob, 10 ether);
        assertEq(miERC20.allowance(alice, bob), 10 ether);
        console2.log("AllowanceBob", miERC20.allowance(alice, bob));
    }

    function testMiERC20EmitsApproval() public {
        vm.startPrank(alice);
        deal(address(miERC20), alice, 100 ether);
        vm.expectEmit();
        emit Approval(alice, bob, 10 ether);
        miERC20.approve(bob, 10 ether);
    }

    function testMiERC20TransferFrom() public {
        vm.startPrank(alice);
        deal(address(miERC20), alice, 100 ether);
        assertEq(miERC20.balanceOf(alice), 100 ether);
        console2.log("BalanceAntes", miERC20.balanceOf(alice));
        miERC20.transferFrom(alice, carol, 10 ether);
        console2.log("BalanceDespues", miERC20.balanceOf(alice));
        miERC20.approve(bob, 10 ether);
        vm.stopPrank();
        vm.startPrank(bob);
        miERC20.transferFrom(alice, carol, 10 ether);
        console2.log("BalanceDespues", miERC20.balanceOf(alice));
        assertEq(miERC20.balanceOf(alice), 80 * 1e18);
        assertEq(miERC20.balanceOf(carol), 20 * 1e18);
        vm.expectRevert("Error en transferencia");
        miERC20.transfer(bob, 0 ether);
        vm.expectRevert("La direccion de destino no puede ser 0");
        miERC20.transfer(address(0x0), 1 ether);
        vm.expectRevert("Error en transferencia");
        miERC20.transfer(bob, 99 ether);
    }

    function testMiERC20EmitsTransferFrom() public {
        vm.startPrank(alice);
        deal(address(miERC20), alice, 100 ether);
        miERC20.approve(bob, 10 ether);
        vm.startPrank(bob);
        vm.expectEmit();
        emit TransferFrom(alice, carol, 10 ether);
        miERC20.transferFrom(alice, carol, 10 ether);
    }

    function testMiERC20mint() public {
        vm.startPrank(alice);
        miERC20.mint(alice, 20 * 1e18);
        assertEq(miERC20.totalSupply(), 1000020 * 1e18);
        vm.expectRevert("Address can't be 0");
        miERC20.mint(address(0), 20);
        vm.expectRevert("Amount is not enougt");
        miERC20.mint(alice, 0);
        console2.log("Balance alice", miERC20.balanceOf(alice));
        assertEq(miERC20.balanceOf(alice), 20 * 1e18);
    }

    function testMiERC20EmitsMint() public {
        vm.startPrank(alice);

        // Check that the topics 1 and the data are the same as the following emitted event
        vm.expectEmit();

        // The event we expect
        emit Mint(alice, 20);

        // Call the mint function of the contract
        miERC20.mint(alice, 20);
    }

    function testMiERC20burn() public {
        vm.startPrank(alice);
        miERC20.mint(alice, 20);
        console2.log("Balance alice antes", miERC20.balanceOf(alice));
        assertEq(miERC20.balanceOf(alice), 20);
        //vm.expectEmit(true, true);
        //emit miERC20.Burn(alice, 10);
        miERC20.burn(10);
        console2.log("Balance alice despues", miERC20.balanceOf(alice));
        assertEq(miERC20.balanceOf(alice), 10);
        vm.expectRevert("Amount is not enougt");
        miERC20.burn(0);
    }

    function testMiERC20EmitsBurn() public {
        vm.startPrank(alice);
        miERC20.mint(alice, 20);
        vm.expectEmit();
        emit Burn(10);
        miERC20.burn(10);
    }
}

/*pragma solidity ^0.8.21;

contract OverflowExample {
    uint256 public balance;

    function deposit() public payable {
        balance += msg.value;
    }

    function withdraw(uint256 _amount) public {
        require(balance >= _amount, "Insufficient balance");
        balance -= _amount;
        msg.sender.transfer(_amount);
    }
}

pragma solidity ^0.8.21;

contract UnderflowExample {
    uint256 public totalSupply;

    function transfer(uint256 _amount) public {
        require(totalSupply > 0, "Amount can't be 0");
        totalSupply -= _amount;
    }
}*/
