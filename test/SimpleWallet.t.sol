// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console, console2} from "forge-std/Test.sol";
import {SimpleWallet} from "../src/SimpleWallet.sol";

contract HolaTest is Test {
    SimpleWallet public simpleWallet;
    address alice;


    function setUp() public {
        simpleWallet = new SimpleWallet();
        alice = makeAddr("alice");
        vm.deal(alice, 10 ether);
        vm.startPrank(alice);
    }

    function testSimpleWallet() public {
        console.log(simpleWallet.getUserBallance(alice));
        simpleWallet.deposit();
        console.log(simpleWallet.getUserBallance(alice));
        //simpleWallet.withdraw(alice, 0.5 ether);
     }
}