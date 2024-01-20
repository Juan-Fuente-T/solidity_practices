/** 
2 . Para el segundo ejercicio, replicarás el ejercicio 1 utilizando el patrón UUPS. Para ello,
deberás:

El objetivo de este ejercicio será practicar la realización de upgrades utilizando UUPS.
Recuerda que en el patrón UUPS los upgrades se realizan desde la implementación (no el
proxy). El proxy simplemente actúa como un contrato que redirige llamadas a la
implementación y que guarda los datos. Las implementaciones son las que contienen la
lógica de hacer upgrade mediante la función upgradeToAndCall() que podemos encontrar en
el código del UUPS. Esta función recibe dos parámetros: newImplementation (que será la
nueva implementación a la que queramos hacer upgrade), y data (que deberemos dejar
vacía). Deberás testear que el upgrade se realiza de forma correcta y la calculadora
finalmente devuelve los valores correctos.
a. Utilizar la plantilla del proxy ERC1967 de OpenZeppelin. Este contrato actúa de la
misma que el Proxy del ejercicio 1, sin necesidad de que tengamos que crear nosotros
el proxy desde cero. Así, crearemos un contrato Proxy que herede de ERC1967, y esto
será to.do!
b. Las implementaciones de la calculadora deberán ser las mismas que en el ejercicio 1
(ImplementaciónV1, hecha por nosotros, e ImplementaciónV2, hecha por tí), con una
pequeña modificación. Ambas implementaciones deberán heredar la plantilla
UUPSUpgreadable
*/
// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;
import "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";

contract Proxy1967_UUPS is ERC1967Proxy {
    constructor(
        address newImplementacionV1,
        bytes memory _data
    ) ERC1967Proxy(newImplementacionV1, _data) {}

    function getImplementation() external view returns (address) {
        return _implementation();
    }
}

/*contract UUPSProxy is ERC1967Proxy(implementation) {
    //Implementation public implementationV1;

function _authorizeUpgrade(address newImplementation) internal virtual;

}*/
/*contract Proxy1967_UUPS {
    address public implementation;
    ERC1967Proxy erc1967;

    constructor(address newImplementacionV1) {
        implementation = newImplementacionV1;
        erc1967 = new ERC1967Proxy(address(implementation), "");
    }
}
*/
