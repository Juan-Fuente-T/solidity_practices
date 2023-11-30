/*
Crea un contrato de registro de nombres en el que los usuarios
pueden registrar un nombre único asociado con su dirección.
*/
// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;


contract RegistroNombres{

    error  NombreNoDisponible();

    mapping (address => string) nombres;
    //constructor(){}

    function registrar(string calldata _nombre) public {
        //require(bytes(nombres[msg.sender]).length == 0, "ERROR");
        if (bytes(nombres[msg.sender]).length != 0) {
            revert NombreNoDisponible();
        }
        nombres[msg.sender] = _nombre;
    }

    
    function getNombre() public view returns (string memory) {
        return nombres[msg.sender];
    }
} 