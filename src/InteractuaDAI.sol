// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.4;

interface IDAI {
    function name() external view returns (string memory);

    function totalSupply() external view returns (uint256);
}

contract InteractuaDAI {
    IDAI public dai = IDAI(address(0x6B175474E89094C44Da98b954EedeAC495271d0F)); //la referencia(hash) todavia no es una address hasta que se indique con el cast

    //address public _dai = 0x6B175474E89094C44Da98b954EedeAC495271d0F;
    //IDAI public dai = IDAI(_dai);
    //IDAI public dai;

    /*constructor() {
        dai = IDAI(_dai);
    }*/

    //constructor() {}

    function consultaNombreDAI() external view returns (string memory) {
        return dai.name();
    }

    function consultaTotalSupply() external view returns (uint256) {
        return dai.totalSupply();
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
