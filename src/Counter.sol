// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract Counter {
    error NotOwner();

    event Incremented(uint256 number);

    uint256 public number;
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        if (msg.sender != owner) revert NotOwner();
        //require(msg.sender == owner, "No eres el owner");
        _;
    }

    function setNumber(uint256 _number) public {
        number = _number;
    }

    function increment() public {
        number++;
        if (number == 2) {
            number = 3;
        }
        emit Incremented(number);
    }
}
