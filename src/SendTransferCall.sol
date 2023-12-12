// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

/*
    Tipos de direcciones:

    Las que pueden recibir ethereum (payable):
        EOA = Dirección cual propiedad es un usuario (NO ES UN SMART CONTRACT)
        Smart contracts (PREPARADOS PARA RECIBIR DINERO)

    Las que no pueden recibir ethereum (non-payable):
        Smart contracts (NO ESTAN PREPRARADOS PARA RECIBIR DINERO)
                Excepción: En caso de SELFDESTRUCT (AUTODESTRUCCIÓN)


    1. Los contratos que pueden recibir dinero en sus funciones

    2. Los contratos que pueden recibir dinero en transferencias
    
    Struts 
    variables
    eventos 
    errores
    funciones
*/

contract PuedoRecibirPeroSoloEnLaFuncion {
    function quieroDinero() external payable {
        uint256 valorQueMeHanEnviado = msg.value;
    }
}

contract PuedoRecibirDineroEnTransferencias {
    receive() external payable {
        // Cada vez que reciba una transferencia de ETH ejecutaré este código
        uint256 valorDeTransferencia = msg.value;
    }
}

contract PuedoRecibirDineroDondeSea {
    fallback() external payable {
        uint256 valorDeLaLlamada = msg.value;
    }
}

contract NoPuedoRecibirDinero {
    function hola() public pure returns (string memory Hola) {
        return "Hola";
    }
}

contract EnvioDinero {
    mapping(address => uint256) public balanceOf;

    error ErrorEnviar();

    function enviarConSend(address payable destino) external {
        // La clave del send es que si da error no hace REVERT! Solo correcto = false;
        bool correcto = destino.send(1 ether);

        if (!correcto) revert ErrorEnviar();
    }

    function enviarConTransfer(address payable destino) external {
        // La clave del transfer es que si da error HACE REVERT!
        destino.transfer(1 ether);
    }

    function enviarConCall(address payable destino) external {
        (bool correcto, bytes memory respuesta) = destino.call{value: 1 ether}("");

        if (!correcto) revert ErrorEnviar();
    }

    /*function enviarConDelegateCall(address payable destino) external {
        (bool correcto, bytes memory respuesta) = destino.delegatecall{value: 1 ether}("");
        if(!correcto) revert ErrorEnviar();
        }*/
}
