/*
Simple Wallet: Diseña un contrato de wallet simple que permita a una dirección depositar
y retirar ether. El contrato tendrá una función deposit() que permitirá depositar ether, y
una función withdraw() que permitirá sacarlo. Decide la visibilidad más apropiada para
estas funciones (external/public/private/internal). El contrato deberá tener un owner, que
será el único que podrá retirar el dinero, especificando una cantidad por parámetro en la
función withdraw().
*/

// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract SimpleWallet {
    address owner;

    error notOwner();
    error NotEnoughtEther();

    mapping(address => uint256) userBalance;

    modifier onlyOwner() {
        if (owner != owner) {
            revert notOwner();
        }
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function setOwner(address newOwner) internal onlyOwner {
        owner = newOwner;
    }

    /*function deposit(address, uint256 amount) public payable onlyOwner{ //es necesario que sea payable para recibir ether real, no wrapped
        payable(msg.sender).transfer(amount); 
        totalSupply[msg.sender] += amount; 
    }
    */
    function deposit() public payable onlyOwner {
        //es necesario que sea payable para recibir ether real, no wrapped
        require(msg.value > 0, "Not enough ether");
        userBalance[msg.sender] += msg.value;
    }

    /*
    function deposit(address payable _to) public payable{
        //Es la recomendada para enviar ether
        (bool sent, bytes memory data) = _to.Call{value: msg.value}("");
        require(sent, "Error en la transaccion");
    }
    /* function deposit(uint256 amount) public payable{
        //Es la recomendada para enviar ether
        (bool sent, bytes memory data) = address(this).call{value: amount}("");
        require(sent, "Error en la transaccion");
        //uint256 amount = msg.value;
        totalSupply[msg.sender] += amount; 
    }*/

    function withdraw(address, uint256 amount) public payable onlyOwner {
        if (amount > userBalance[msg.sender]) {
            revert NotEnoughtEther();
        }
        payable(msg.sender).transfer(amount);
        userBalance[msg.sender] -= amount;
    }

    function getUserBallance(address sender) public view returns (uint256) {
        return userBalance[sender];
    }
}
