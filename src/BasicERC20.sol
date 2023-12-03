/*Token Básico ERC20: Implementa un contrato de token básico que tenga funciones para
transferir tokens entre direcciones y consultar el saldo. Sin heredar de ningún contrato
plantilla, este contrato deberá implementar el estándar ERC20*/

// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {console} from "forge-std/Test.sol";

contract BasicERC20{

    string public name;
    string public  simbol;
    uint8 public immutable decimals;
    uint256 public totalSupply;

    error InsuficientAllowance();

    mapping (address => uint256) public balances;
    mapping (address => mapping(address => uint256)) public allowance;

    constructor(){
        name = "Tokencito";
        simbol = "TITO";
        decimals = 18;
        totalSupply = 10 * 1e18;
        balances[msg.sender] = totalSupply;
    }

    function approve(address _to, uint256 _amount) public{
        allowance[_to] [msg.sender]+= _amount;
    }

    function transfer(address to, uint256 amount) public returns(bool success) {
        require(to != address(0), "No puede ser la address 0");
        require(!(amount > balances[msg.sender]), "Balance insuficiente");
        balances[to] += amount;
        balances[msg.sender] -= amount;
        return true;
    }
    function transferFrom(address from, address to, uint256 amount) public returns(bool success){
        require(to != address(0), "El destino no puede ser la address 0");
        require(from != address(0), "El origen no puede ser la address 0");
        require(balances[from] >= amount, "Balance insuficiente");
        if (allowance[from] [msg.sender]< amount){
            revert InsuficientAllowance();
        }
        /*console.log("balance msg.sender", balances[msg.sender]);
        console.log("balance to", balances[to]);
        console.log("balance from", balances[from]);
        console.log("amount", amount);*/
        balances[from] -= amount;
        balances[to] += amount;
        allowance[from][msg.sender]-= amount;
        return true;
    }

    function balanceOf(address user) public view returns(uint256){
        return balances[user];
    }

    function getTotalSupply() public view returns(uint256){
        return totalSupply;
    }
}