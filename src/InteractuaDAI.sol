// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.21;

interface IDAI {
    function name() external view returns (string memory);
}

contract InteractuaDAI {
    IDAI public DAI = IDAI(0x6B175474E89094C44Da98b954EedeAC495271d0F);

    /*constructor(address _DAI) {
        DAI = IDAI(_DAI);
    }*/

    function consultaNombreDAI() external view returns (string memory) {
        string memory loquesea = DAI.name();
        return loquesea;
    }
}

/*El objetivo de estos ejercicio es interactuar con contratos externos. En el primer ejercicio,
deberás crear un fork de la red principal de Ethereum (mainnet). En el segundo, el fork
deberá ser de la red de test Sepolia.


1 . Crea un contrato llamado InteractuaDAI. Este contrato deberá:
    a. Tener un constructor que reciba la dirección del token DAI
(0x6b175474e89094c44da98b954eedeac495271d0f) por parámetro, y guardarlo en
una variable llamada token que deberá ser de tipo address.
    b. Tener una función llamada consultaNombreDAI() que devolverá un string. Esta función
llamará a la función name() del token DAI, y devolverá el valor que devuelva dicha
función.
Nota: A parte del contrato, deberás crear una interfaz IDAI que contenga la/s funcion/es
necesarias para poder realizar el ejercicio de forma correcta. El test de este contrato
deberá comprobar que la función consultaNombreDAI() devuelve el valor “Dai
Stablecoin”.
*/
