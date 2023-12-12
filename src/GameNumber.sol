/*
Ejercicio final fase 1: Adivina el Número: Crea un contrato que elija un número aleatorio y
permita a los usuarios adivinarlo, con una recompensa por adivinar el número
correctamente. No hace falta que utilices Chainlink fara generar la aleatoriedad, te
puedes ayudar de utilidades como block.timestamp. La recompensa para el ganador será
de 1 ether. Tendrá 3 funciones:
startNewGame(): reiniciará el juego. Seteará un nuevo blockNumber y un nuevo
targetNumber (número a adivinar). También pondrá la variable gameEnded a false, y la
dirección winner a la dirección 0. Sólo el dueño del contrato podrá llamar esta
función.
makeGuess(): el msg.sender deberá enviar al menos la cantidad de reward (elegida por
tí y seteada en el constructor). Recibirá por parámetro el número a elegir, que deberá
ser entre 1 y 9. Si el número se adivina, se seteará winner a msg.sender, y gameEnded
se pondrá a true. Sólo se podrá llamar esta función si el juego no ha terminado
(gameEnded es false).
claimReward(): permitirá al ganador (y sólo al ganador) retirar el reward.
*/

// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {ERC20} from "lib/forge-std/src/ERC20.sol";
import {console} from "lib/forge-std/src/Test.sol";

interface IERC20 {
    function transferFrom(address from, address to, uint256 amount) external returns (bool);
    function approve(address spender, uint256 amount) external returns (bool);
}

contract GameNumber {
    address owner;
    address public winner;
    uint256 public ethSupply;
    uint256 public reward;
    uint256 public bet;
    uint256 blockNumber;
    uint256 targetNumber;
    bool public endGame;

    error DebeSerMayorQueCero();

    constructor(uint256 _reward, uint256 _bet, uint256 _initialSupply) {
        reward = _reward;
        bet = _bet;
        owner = msg.sender;
        ethSupply = _initialSupply;
        endGame = true;
    }

    function startNewGame() public {
        require(msg.sender == owner, "NotOwner");
        require(endGame = true, "El juego no ha terminado");
        //blockNumber = block.number;
        blockNumber = 123456789;
        //targetNumber = uint256(blockhash(blockNumber)) % 10;
        //targetNumber = block.number % 10;
        targetNumber = 7;
        endGame = false;
        winner = address(0x0);
    }

    function makeGuess(uint256 _targetNumber) public payable {
        if (_targetNumber == 0) {
            revert DebeSerMayorQueCero();
        }
        //require(_targetNumber > 0 && targetNumber < 10, "ChooseAnotherNumber");
        //bool sent = IERC20(msg.sender).transferFrom(msg.sender, address(this), reward);
        //recuerda se puede obtener ether nativo de una address si esa no toma la iniciativa y usa transfer, send o call
        //require(sent, "FailTransaction");
        require(msg.value >= bet, "The bet is not enought");
        ethSupply += msg.value;
        if (_targetNumber == targetNumber) {
            winner = msg.sender;
            endGame = true;
        }
    }

    function claimReward() public {
        require(winner == msg.sender, "No eres el ganador");
        require(endGame, "El juego aun no ha terminado o no has sido el ganador");
        payable(msg.sender).transfer(reward); //para poder enviar ether siempre hay que hacerlo payable
        ethSupply -= reward;
    }

    function getTargetNumber() public view returns (uint256) {
        return targetNumber;
    }

    receive() external payable {}
    fallback() external payable {
        // Reenvía el Ether al propietario del contrato
        //payable(owner).transfer(msg.value);
    }
}
