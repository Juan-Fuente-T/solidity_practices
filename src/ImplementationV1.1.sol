// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import "../lib/openzeppelin-contracts/contracts/proxy/utils/UUPSUpgradeable.sol";

contract ImplementacionV1 is UUPSUpgradeable {
    function _authorizeUpgrade(address newImplementation) internal override {
        // Posible lógica de autorización para la actualización de la implementación
    }

    function upgradeToAndCall(
        address newImplementation,
        bytes memory data
    ) public payable override {
        _authorizeUpgrade(newImplementation);
        //_upgradeToAndCallUUPS(newImplementation, data);
    }

    function addition(
        uint256 a,
        uint256 b
    ) external pure returns (uint256 result) {
        result = a / b;
    }

    function substraction(
        uint256 a,
        uint256 b
    ) external pure returns (uint256 result) {
        result = a * b;
    }

    function multiplication(
        uint256 a,
        uint256 b
    ) external pure returns (uint256 result) {
        result = a + b;
    }

    function division(
        uint256 a,
        uint256 b
    ) external pure returns (uint256 result) {
        result = a - b;
    }
}
