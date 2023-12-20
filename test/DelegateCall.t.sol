// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.21;

import {Test, console, console2} from "lib/forge-std/src/Test.sol";
import {ContratoDelegateCall} from "../src/DelegateCall.sol";
import {Counter} from "../src/Counter.sol";

contract DelegateCallTest is Test {
    Counter public counter;
    ContratoDelegateCall public contratoDelegateCall;

    function setUp() public {
        counter = new Counter();
        contratoDelegateCall = new ContratoDelegateCall(address(counter));
    }

    function testDelegateCallIncrement() public {
        contratoDelegateCall.ejecutaDelegateCallIncrement();
        assertEq(contratoDelegateCall.number(), 1);
        assertEq(counter.number(), 0);
        contratoDelegateCall.ejecutaDelegateCallSetNumber(99);
        assertEq(contratoDelegateCall.number(), 99);
        console2.log("Number en Counter: ", counter.number());
        console2.log(
            "Number en ContratoDelegateCall: ",
            contratoDelegateCall.number()
        );
    }
}
