// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console, console2} from "lib/forge-std/src/Test.sol";
import {RecibirEtherPayable} from "../src/RecibirEtherPayable.sol";

contract RecibirEtherPayableTest is Test {
    RecibirEtherPayable public recibirEtherPayable;
    address alice;

    event Deposited(address indexed depositor, uint256 indexed amount);

    function setUp() public {
        recibirEtherPayable = new RecibirEtherPayable();
        alice = makeAddr("alice");
        startHoax(alice, 100 ether); //similar al starPrank pero con fondos, la siguientes llamadas serán de alice. alice debe estar inicilializada en el setup
    }

    function testRecibirEtherPayableEnviar() public {
        assertEq(0 ether, address(recibirEtherPayable).balance);
        assertEq(alice.balance, 100 ether);
        console2.log("BalanceContratoAntes", address(recibirEtherPayable).balance);
        console2.log("BalanceAliceAntes", alice.balance);
        recibirEtherPayable.recibirEther{value: 5 ether}();
        (bool sent2,) =
            payable(address(recibirEtherPayable)).call{value: 5 ether}(abi.encodeWithSignature("recibirEther()"));
        assertEq(10 ether, address(recibirEtherPayable).balance);
        assertEq(alice.balance, 90 ether);
        console2.log(address(recibirEtherPayable).balance);
        console2.log("BalanceAliceDespues", alice.balance);
        console2.log("BalanceContratoDespues", address(recibirEtherPayable).balance);
    }

    function testRecibirEtherPayableEnviarFalla() public {
        /*try recibirEtherPayable.recibirEther{
            value : 0
            }();
            catchError("No se envió ninguna moneda.");
        }*/
        vm.expectRevert(abi.encodeWithSignature("MinAmountNonReached()"));
        recibirEtherPayable.recibirEther{value: 5 * 1e17}();
        vm.expectRevert(abi.encodeWithSignature("MaxAmountReached()"));
        recibirEtherPayable.recibirEther{value: 11 * 1e18}();
        recibirEtherPayable.recibirEther{value: 10 * 1e18}();
        recibirEtherPayable.recibirEther{value: 10 * 1e18}();
        recibirEtherPayable.recibirEther{value: 10 * 1e18}();
        recibirEtherPayable.recibirEther{value: 10 * 1e18}();
        recibirEtherPayable.recibirEther{value: 5 * 1e18}();
        vm.expectRevert(abi.encodeWithSignature("MaxBalanceReached()"));
        recibirEtherPayable.recibirEther{value: 6 * 1e18}();
    }

    function testRecibirEtherPayableEmitsDeposited() public {
        vm.expectEmit();
        emit Deposited(alice, 5 ether);
        recibirEtherPayable.recibirEther{value: 5 ether}();
    }
}

/*
contract RecibirEtherPayableTest is Test {
    RecibirEtherPayable payableContract;

    function setUp() public {
        payableContract = new RecibirEtherPayable();
    }

    function testRecibirEther() public {
        vm.deal(payableContract, 100);

        // Debería fallar debido al monto mínimo
        vm.expectRevert(payableContract.recibirEther{value: 50 ether})
        ;

        // Debería fallar debido al monto máximo
        vm.expectRevert(payableContract.recibirEther{value: 200 ether})
        ;

        // Debería fallar debido al balance máximo
        vm.deal(payableContract, 40);
        vm.expectRevert(payableContract.recibirEther{value: 50 ether})
        ;

        // Debería funcionar correctamente
        vm.deal(payableContract, 5);
        payableContract.recibirEther{value: 1 ether};

        assertEq(address(payableContract).balance, 1 ether);
    }
}*/
