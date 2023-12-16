// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console, console2} from "lib/forge-std/src/Test.sol";
import {RecibirEtherReceive} from "../src/RecibirEtherReceive.sol";

//IMPORTANTE ¿Que esta pasando con transfer? que me esta dando error por gas

contract RecibirEtherReceiveTest is Test {
    RecibirEtherReceive public recibirEtherReceive;
    address alice;

    event Deposited(address indexed depositor, uint256 indexed amount);
    event Withdraw(address indexed withdrawer, uint256 indexed amount);

    function setUp() public {
        recibirEtherReceive = new RecibirEtherReceive();
        alice = makeAddr("alice");
        startHoax(alice, 100 ether); //similar al starPrank pero con fondos, la siguientes llamadas serán de alice. alice debe estar inicilializada en el setup
    }

    function testRecibirEtherReceiveEnviar() public {
        assertEq(0 ether, address(recibirEtherReceive).balance);
        assertEq(alice.balance, 100 ether);
        console2.log("BalanceContratoAntes", address(recibirEtherReceive).balance);
        console2.log("BalanceAliceAntes", alice.balance);
        //payable(address(recibirEtherReceive)).transfer(5 ether);
        (bool sent,) = payable(address(recibirEtherReceive)).call{value: 4 ether}("");
        assertEq(4 ether, address(recibirEtherReceive).balance);
        assertEq(alice.balance, 96 ether);
        (bool sent2,) = payable(address(recibirEtherReceive)).call{value: 5 ether}("");
        assertEq(9 ether, address(recibirEtherReceive).balance);
        assertEq(alice.balance, 91 ether);
        console2.log("BalanceAliceDespues", alice.balance);
        console2.log("BalanceAliceInternoContrato", recibirEtherReceive.balances(alice));
        console2.log("BalanceContratoDespues", address(recibirEtherReceive).balance);
    }

    function testRecibirEtherReceiveEmitsDeposited() public {
        vm.expectEmit();
        emit Deposited(alice, 5 ether);
        payable(address(recibirEtherReceive)).call{value: 5 ether}("");
    }

    function testRecibirEtherReceiveWithdrawWithCall() public {
        //payable(address(recibirEtherReceive)).transfer(15 ether);
        payable(address(recibirEtherReceive)).call{value: 15 ether}("");
        assertEq(15 ether, address(recibirEtherReceive).balance);
        assertEq(alice.balance, 85 ether);
        recibirEtherReceive.withdrawWithCall(5 ether);
        assertEq(10 ether, address(recibirEtherReceive).balance);
        assertEq(alice.balance, 90 ether);
    }

    function testRecibirEtherReceiveEmitsWithdrawCall() public {
        payable(address(recibirEtherReceive)).call{value: 5 ether}("");
        vm.expectEmit();
        emit Withdraw(alice, 5 ether);
        recibirEtherReceive.withdrawWithCall(5 ether);
    }

    function testRecibirEtherReceiveWithdrawWithCallFalla() public {
        assertEq(0 ether, address(recibirEtherReceive).balance);
        assertEq(alice.balance, 100 ether);
        payable(address(recibirEtherReceive)).call{value: 5 ether}("");
        vm.expectRevert(abi.encodeWithSignature("InsuficientBalance()"));
        recibirEtherReceive.withdrawWithCall(15 * 1e18);
        assertEq(5 ether, address(recibirEtherReceive).balance);
        assertEq(alice.balance, 95 ether);
        vm.expectRevert(abi.encodeWithSignature("InsuficientBalance()"));
        recibirEtherReceive.withdrawWithCall(0 ether);
    }

    function testRecibirEtherReceiveWithdrawWithSend() public {
        //payable(address(recibirEtherReceive)).transfer(15 ether);
        payable(address(recibirEtherReceive)).call{value: 15 ether}("");
        assertEq(15 ether, address(recibirEtherReceive).balance);
        assertEq(alice.balance, 85 ether);
        recibirEtherReceive.withdrawWithSend(5 ether);
        assertEq(10 ether, address(recibirEtherReceive).balance);
        assertEq(alice.balance, 90 ether);
    }

    function testRecibirEtherReceiveEmitsWithdrawSend() public {
        payable(address(recibirEtherReceive)).call{value: 5 ether}("");
        vm.expectEmit();
        emit Withdraw(alice, 5 ether);
        recibirEtherReceive.withdrawWithSend(5 ether);
    }

    function testRecibirEtherReceiveWithdrawWithSendFalla() public {
        assertEq(0 ether, address(recibirEtherReceive).balance);
        assertEq(alice.balance, 100 ether);
        payable(address(recibirEtherReceive)).call{value: 5 ether}("");
        vm.expectRevert(abi.encodeWithSignature("InsuficientBalance()"));
        recibirEtherReceive.withdrawWithCall(15 * 1e18);
        assertEq(5 ether, address(recibirEtherReceive).balance);
        assertEq(alice.balance, 95 ether);
        vm.expectRevert(abi.encodeWithSignature("InsuficientBalance()"));
        recibirEtherReceive.withdrawWithCall(0 ether);
    }

    function testRecibirEtherReceiveWithdrawWithTransfer() public {
        //payable(address(recibirEtherReceive)).transfer(15 ether);
        payable(address(recibirEtherReceive)).call{value: 15 ether}("");
        assertEq(15 ether, address(recibirEtherReceive).balance);
        assertEq(alice.balance, 85 ether);
        recibirEtherReceive.withdrawWithCall(5 ether);
        assertEq(10 ether, address(recibirEtherReceive).balance);
        assertEq(alice.balance, 90 ether);
    }

    function testRecibirEtherReceiveEmitsWithdrawTransfer() public {
        payable(address(recibirEtherReceive)).call{value: 5 ether}("");
        vm.expectEmit();
        emit Withdraw(alice, 5 ether);
        recibirEtherReceive.withdrawWithTransfer(5 ether);
    }

    function testRecibirEtherReceiveWithdrawWithTransferFalla() public {
        assertEq(0 ether, address(recibirEtherReceive).balance);
        assertEq(alice.balance, 100 ether);
        payable(address(recibirEtherReceive)).call{value: 5 ether}("");
        vm.expectRevert(abi.encodeWithSignature("InsuficientBalance()"));
        recibirEtherReceive.withdrawWithTransfer(15 * 1e18);
        assertEq(5 ether, address(recibirEtherReceive).balance);
        assertEq(alice.balance, 95 ether);
        vm.expectRevert(abi.encodeWithSignature("InsuficientBalance()"));
        recibirEtherReceive.withdrawWithCall(0 ether);
    }
}
