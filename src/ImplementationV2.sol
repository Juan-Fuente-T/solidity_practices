// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/proxy/utils/UUPSUpgradeable.sol";

contract ImplementationV2 is UUPSUpgradeable {
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(
            msg.sender == owner,
            "Only the contract's owner can call this method"
        );
        _;
    }

    function initialize() external {
        owner = msg.sender;
    }

    function _authorizeUpgrade(
        address newImplementation
    ) internal override onlyOwner {
        // Posible lógica de autorización para la actualización de la implementación
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
