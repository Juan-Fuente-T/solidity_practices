// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract Hola {
    uint256 cantidadHolas;

    function diHola() public returns (string memory) {
        cantidadHolas++;
        return "Hola";
    }

    function getCantidadHolas() public view returns (uint256) {
        return cantidadHolas;
    }
}
