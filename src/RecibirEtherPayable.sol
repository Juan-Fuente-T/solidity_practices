// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.21;

contract RecibirEtherPayable {
    event Deposited(address indexed depositor, uint256 indexed amount);

    error MinAmountNonReached();
    error MaxAmountReached();
    error MaxBalanceReached();

    function recibirEther() external payable {
        if (msg.value < 1 ether) {
            revert MinAmountNonReached();
        }
        if (msg.value > 10 ether) {
            revert MaxAmountReached();
        }
        //NO ES NECESARIO agregar el valor a nuestro balance total, se hace de modo automático internamente
        //address(this).balance += msg.value;
        if (address(this).balance > 50 ether) {
            revert MaxBalanceReached();
        }
        emit Deposited(msg.sender, msg.value);
    }
}

/*
El objetivo de estos ejercicio es explorar las diferentes maneras que ofrece Solidity para que
un contrato reciba ether, y cómo realizar transferencias.
Nota: Ambos contratos deberán ser testeados correctamente, comprobando que tanto los
errores como los eventos se emiten y ejecutan de forma correcta, tal y como vimos en los
ejerecicios anteriores.

1. Crea un contrato llamado RecibirEtherPayable . Este contrato sólo tendrá una función
payable llamada recibirEther(), que deberá asegurarse de que quien la llama transfiere
una cantidad mínima de 1 ether (si no se deberá lanzar el error MinAmountNotReached()),
y una cantidad máxima de 10 ether (si se supera dicha cantidad se deberá lanzar el error
MaxAmountReached()). También se deberá controlar que el balance total del contrato no
supere los 50 ether (contando la cantidad que se está transfiriendo al llamar a la función
recibirEther()), en cuyo caso deberá lanzarse el error MaxBalanceReached(). Si to.do
funciona correctamente, el evento Deposited(address depositor, uint256 amount) deberá
lanzarse.
*/
