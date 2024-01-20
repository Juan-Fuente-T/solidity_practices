//SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {UUPSUpgradeable} from "@openzeppelin/contracts/proxy/utils/UUPSUpgradeable.sol";

contract ImplementationV2 is UUPSUpgradeable {
    function _authorizeUpgrade(address newImplementation) internal override {
        // Lógica de autorización para la actualización de la implementación
    }

    function addition(
        uint256 a,
        uint256 b
    ) external pure returns (uint256 result) {
        result = a + b;
    }

    function substraction(
        uint256 a,
        uint256 b
    ) external pure returns (uint256 result) {
        result = a - b;
    }

    function multiplication(
        uint256 a,
        uint256 b
    ) external pure returns (uint256 result) {
        result = a * b;
    }

    function division(
        uint256 a,
        uint256 b
    ) external pure returns (uint256 result) {
        result = a / b;
    }
}
