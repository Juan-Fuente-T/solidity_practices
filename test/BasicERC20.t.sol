// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console, console2} from "lib/forge-std/src/Test.sol";
import {BasicERC20} from "../src/BasicERC20.sol";

contract BasicERC20Test is Test {
    BasicERC20 public basicERC20;
    address alice;
    address bob;

    function setUp() public {
        alice = makeAddr("alice");
        bob = makeAddr("bob");
        //vm.deal(alice, 10 ether);
        vm.startPrank(alice);
        basicERC20 = new BasicERC20();
    }

    function testBasicERC20() public {
        console.log("TotalSupply", basicERC20.totalSupply());
        console.log("Balance Alice", basicERC20.balanceOf(alice));

        // Transferir de Alice a Bob
        bool sent = basicERC20.transfer(bob, 1e18);
        console.log("Resultado Transfer", sent);

        console.log("TotalSupply", basicERC20.totalSupply());
        console.log("Balance Alice despues de Transfer", basicERC20.balanceOf(alice));
        console.log("Balance Bob despues de Transfer", basicERC20.balanceOf(bob));

        //basicERC20.approve(bob, 5 * 1e17);
        //bool success = basicERC20.transferFrom(bob, alice, 5 * 1e17);
        basicERC20.approve(alice, 1000);
        basicERC20.transferFrom(alice, bob, 1000);

        console.log("TotalSupply", basicERC20.totalSupply());
        console.log("Balance Alice despues TransferFrom", basicERC20.balanceOf(alice));
        console.log("Balance Bob despues TransferForm", basicERC20.balanceOf(bob));
    }
}
