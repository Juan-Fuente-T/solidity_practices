// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.21;

import {Test, console, console2} from "lib/forge-std/src/Test.sol";
import {Proxy} from "../src/Proxy.sol";
import {ImplementationV1} from "../src/ImplementationV1.sol";
import {ImplementationV2} from "../src/ImplementationV2.sol";

contract ProxyTest is Test {
    Proxy public proxy;
    ImplementationV1 public implementation;
    ImplementationV2 public implementationV2;

    //uint256 sepoliaFork;
    //string SEPOLIA_RPC_URL = vm.envString("SEPOLIA_RPC_URL");

    //event Deposited(address indexed depositor, uint256 indexed amount);
    //event Withdraw(address indexed withdrawer, uint256 indexed amount);

    function setUp() public {
        implementation = new ImplementationV1();
        proxy = new Proxy(address(implementation));
        implementationV2 = new ImplementationV2();
        console.logAddress(address(implementation));
        console.logAddress(address(proxy));
    }

    /*function testProxyAddition1() public {
        uint256 result = proxy.callAddition(10, 5);
        console2.log("REsult", result);
        assertEq(result, 2);
    }*/

    /*function testProxyAddition2() public {
        (bool success, bytes memory data) = address(proxy).call(
            abi.encodeWithSignature("addition(uint256,uint256)", 10, 5)
        );
        require(success, "Delegatecall failed");
        console.log("success", success);
        uint256 result = abi.decode(data, (uint256));
        console.log("result", result);
        //assertEq(result, 15, "Wrong result");*/

    function testAdditionV1() public {
        console.logAddress(proxy.implementation());
        (bool success, bytes memory data) = address(proxy).call(
            abi.encodeWithSignature("addition(uint256,uint256)", 10, 5)
        );
        require(success, "Call failed");
        uint256 result = abi.decode(data, (uint256));
        assertEq(2, result);
    }

    function testSubstractionV1() public {
        (bool success, bytes memory data) = address(proxy).call(
            abi.encodeWithSignature("substraction(uint256,uint256)", 10, 8)
        );
        require(success, "Delegatecall failed");
        uint256 result = abi.decode(data, (uint256));
        assertEq(
            result,
            80,
            "Substraction function should return correct result"
        );
    }

    function testMultiplicationV1() public {
        (bool success, bytes memory data) = address(proxy).call(
            abi.encodeWithSignature("multiplication(uint256,uint256)", 10, 8)
        );
        require(success, "Delegatecall failed");
        uint256 result = abi.decode(data, (uint256));
        assertEq(
            result,
            18,
            "Multiplication function should return correct result"
        );
    }

    function testDivisionV1() public {
        (bool success, bytes memory data) = address(proxy).call(
            abi.encodeWithSignature("division(uint256,uint256)", 10, 2)
        );
        require(success, "Delegatecall failed");
        uint256 result = abi.decode(data, (uint256));
        assertEq(result, 8, "Division function should return correct result");
    }

    function testProxyUpgrade() public {
        console.log("ImplementationAntes", proxy.implementation());
        assertEq(address(implementation), proxy.implementation());
        proxy.upgrade(address(implementationV2));
        console.log("ImplementationDespues", proxy.implementation());
        assertEq(address(implementationV2), proxy.implementation());
    }

    function testAdditionV2() public {
        proxy.upgrade(address(implementationV2));
        (bool success, bytes memory data) = address(proxy).call(
            abi.encodeWithSignature("addition(uint256,uint256)", 10, 5)
        );
        uint256 result = abi.decode(data, (uint256));
        assertEq(15, result, "Addition function should return correct result");
    }

    function testSubstractionV2() public {
        proxy.upgrade(address(implementationV2));
        (bool success, bytes memory data) = address(proxy).call(
            abi.encodeWithSignature("substraction(uint256,uint256)", 10, 8)
        );
        uint256 result = abi.decode(data, (uint256));
        assertEq(
            result,
            2,
            "Substraction function should return correct result"
        );
    }

    function testMultiplicationV2() public {
        proxy.upgrade(address(implementationV2));
        (bool success, bytes memory data) = address(proxy).call(
            abi.encodeWithSignature("multiplication(uint256,uint256)", 10, 8)
        );
        uint256 result = abi.decode(data, (uint256));
        assertEq(
            result,
            80,
            "Multiplication function should return correct result"
        );
    }

    function testDivisionV2() public {
        proxy.upgrade(address(implementationV2));
        (bool success, bytes memory data) = address(proxy).call(
            abi.encodeWithSignature("division(uint256,uint256)", 10, 2)
        );
        uint256 result = abi.decode(data, (uint256));
        assertEq(result, 5, "Division function should return correct result");
    }
}
