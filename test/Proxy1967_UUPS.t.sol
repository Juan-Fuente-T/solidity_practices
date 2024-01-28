// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {Test, console, console2} from "lib/forge-std/src/Test.sol";
import {Proxy1967_UUPS} from "../src/Proxy1967_UUPS.sol";
import {ImplementationV1} from "../src/ImplementationV1.sol";
import {ImplementationV2} from "../src/ImplementationV2.sol";

interface IImplementation {
    function upgradeToAndCall(address, bytes memory) external payable;
}

contract Proxy1967_UUPSTest is Test {
    Proxy1967_UUPS public proxy1967_UUPS;
    ImplementationV1 public implementation;
    ImplementationV2 public implementationV2;

    //uint256 sepoliaFork;
    //string SEPOLIA_RPC_URL = vm.envString("SEPOLIA_RPC_URL");

    function setUp() public {
        implementation = new ImplementationV1();
        proxy1967_UUPS = new Proxy1967_UUPS(
            address(implementation),
            abi.encodeWithSignature("initialize()")
        );
        implementationV2 = new ImplementationV2();
        console.logAddress(address(implementation));
        console.logAddress(address(implementationV2));
        console.log("Owner", implementation.owner());
    }

    //Setup para fork:

    /* function setUp() public {
        implementation = ImplementationV1(
            address(0x2612FE2F5a364Ca226EA165f41435E85E3FA767f)
        );
        //proxy1967_UUPS = Proxy1967_UUPS(address(0x78070uu878u8yu8uyo98yuiu9u098));
        //proxy1967_UUPS = "0xDff86b1bf6AfBb1405C35C741994723B21983C91";
        proxy1967_UUPS = new Proxy1967_UUPS(address(implementation), bytes(""));
        //proxy1967_UUPS = new Proxy1967_UUPS(address(implementation), );
        implementationV2 = ImplementationV2(
            address(0x23A447DF16c65bf64c6FeE7891466Ce547A75648)
        );
        console.logAddress(address(implementation));
        console.logAddress(address(implementationV2));
        //sepoliaFork = vm.createFork(SEPOLIA_RPC_URL);
        //vm.selectFork(sepoliaFork);
        vm.createSelectFork(SEPOLIA_RPC_URL);
        assertEq(vm.activeFork(), sepoliaFork);
    }*/

    function testAdditionV1() public {
        console.log("Funciona");
        //console.log(proxy1967_UUPS.implementation());
        //console.logAddress(proxy1967_UUPS._implementation());
        (bool success, bytes memory data) = address(proxy1967_UUPS).call(
            abi.encodeWithSignature("addition(uint256,uint256)", 10, 5)
        );
        require(success, "Call failed");
        uint256 result = abi.decode(data, (uint256));
        assertEq(2, result);
    }

    function testSubstractionV1() public {
        (bool success, bytes memory data) = address(proxy1967_UUPS).call(
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
        (bool success, bytes memory data) = address(proxy1967_UUPS).call(
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
        (bool success, bytes memory data) = address(proxy1967_UUPS).call(
            abi.encodeWithSignature("division(uint256,uint256)", 10, 2)
        );
        require(success, "Delegatecall failed");
        uint256 result = abi.decode(data, (uint256));
        assertEq(result, 8, "Division function should return correct result");
    }

    function testProxyUpgrade() public {
        console.log("ImplementationAntes", proxy1967_UUPS.getImplementation());
        assertEq(address(implementation), proxy1967_UUPS.getImplementation());
        /*(bool success, ) = address(proxy1967_UUPS).call(
            abi.encodeWithSignature(
                "upgradeToAndCall(address,bytes)",
                address(implementationV2),
                ""
            )
        );*/
        //alternativa para hacer la llamada sin hacer call, usar una interface para llamar directamente a la funcion
        IImplementation(address(proxy1967_UUPS)).upgradeToAndCall(
            address(implementationV2),
            ""
        );
        console.log(
            "ImplementationDespues",
            proxy1967_UUPS.getImplementation()
        );
        assertEq(address(implementationV2), proxy1967_UUPS.getImplementation());
    }

    function testAdditionV2() public {
        (bool cambio, bytes memory datos) = address(proxy1967_UUPS).call(
            abi.encodeWithSignature(
                "upgradeToAndCall(address,bytes)",
                address(implementationV2),
                ""
            )
        );
        (bool success, bytes memory data) = address(proxy1967_UUPS).call(
            abi.encodeWithSignature("addition(uint256,uint256)", 10, 5)
        );
        uint256 result = abi.decode(data, (uint256));
        assertEq(15, result, "Addition function should return correct result");
    }

    function testSubstractionV2() public {
        (bool cambio, ) = address(proxy1967_UUPS).call(
            abi.encodeWithSignature(
                "upgradeToAndCall(address,bytes)",
                address(implementationV2),
                ""
            )
        );
        (bool success, bytes memory data) = address(proxy1967_UUPS).call(
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
        (bool cambio, bytes memory datos) = address(proxy1967_UUPS).call(
            abi.encodeWithSignature(
                "upgradeToAndCall(address,bytes)",
                address(implementationV2),
                ""
            )
        );
        (bool success, bytes memory data) = address(proxy1967_UUPS).call(
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
        (bool cambio, bytes memory datos) = address(proxy1967_UUPS).call(
            abi.encodeWithSignature(
                "upgradeToAndCall(address,bytes)",
                address(implementationV2),
                ""
            )
        );
        (bool success, bytes memory data) = address(proxy1967_UUPS).call(
            abi.encodeWithSignature("division(uint256,uint256)", 10, 2)
        );
        uint256 result = abi.decode(data, (uint256));
        assertEq(result, 5, "Division function should return correct result");
    }
}
