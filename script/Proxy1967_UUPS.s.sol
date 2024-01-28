// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console2} from "lib/forge-std/src/Script.sol";
import "../src/ImplementationV1.sol";
import "../src/ImplementationV2.sol";
import "../src/Proxy1967_UUPS.sol";

//es necesario agregar el RPC_URl y la ETHERSCAN_API_KEY AL foundry.toml

//contract Proxy1967UUPSScript is Script {
contract MyScript is Script {
    function setUp() public {}

    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);
        //vm.broadcast();
        ImplementationV1 implementationV1 = new ImplementationV1();
        Proxy1967_UUPS proxy = new Proxy1967_UUPS(
            address(implementationV1),
            abi.encodeWithSignature("initialize()")
        );
        ImplementationV2 implementationV2 = new ImplementationV2();
        (bool success, ) = address(proxy).call(
            abi.encodeWithSignature(
                "upgradeToAndCall(address,bytes)",
                address(implementationV2),
                ""
            )
        );
        vm.stopBroadcast();
    }
}

/**
import "forge-std/Script.sol";
import "../src/ImplementacionV1.sol";
import "../src/Proxy1967_UUPS.sol";

contract MyScript is Script {
    function run() external {
        string memory rpcUrl = "https://eth-sepolia.g.alchemy.com/v2/QF_rlvr4V0ZORimK7ysBA4mJvl0Bk47c";
        string memory privateKey = "c45f85a5ec0d4bd6c655c9fc2c505c3b6576a9d81e73635f77deb457aa68f3d9";
        string memory contractPath1 = "src/ImplementacionV1.sol";
        string memory contractPath2 = "src/Proxy1967_UUPS.sol";

        forge.create(
            rpcUrl,
            privateKey,
            contractPath1
        );

        forge.create(
            rpcUrl,
            privateKey,
            contractPath2,
            address(0), // Dirección del contrato ImplementacionV1
            address(1) // Dirección adicional que deseas pasar como parámetro
        );

        forge.upgradeToAndCall(
            rpcUrl,
            privateKey,
            address(2), // Dirección del contrato Proxy1967_UUPS
            address(3), // Dirección de la nueva implementación
            "datos de llamada" // Datos adicionales para la función upgradeToAndCall
        );
    }
}

     */
