// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.21;

contract RecibirEtherReceive {
    mapping(address => uint256) balances;

    event Deposited(address indexed depositor, uint256 indexed amount);
    event Withdraw(address indexed withdrawer, uint256 indexed amount);

    error InsuficientBalance();
    error FailTransaction();

    function withdrawWithCall(uint256 amount) external payable {
        if (balances[msg.sender] > amount) {
            revert InsuficientBalance();
        }

        balances[msg.sender] -= amount;
        (bool sent, ) = payable(msg.sender).call{value: amount}("");
        if (!sent) {
            revert FailTransaction();
        }
        emit Withdraw(msg.sender, amount);
    }

    function withdrawWithTransfer(uint256 amount) external payable {
        if (balances[msg.sender] < amount) {
            revert InsuficientBalance();
        }
        balances[msg.sender] -= amount;
        payable(msg.sender).transfer(amount);
        emit Withdraw(msg.sender, amount);
    }

    function withdrawWithSend(uint256 amount) external payable {
        if (balances[msg.sender] < amount) {
            revert InsuficientBalance();
        }
        balances[msg.sender] -= amount;
        bool sent = payable(msg.sender).send(amount);
        if (!sent) {
            revert FailTransaction();
        }
    }

    receive() external payable {
        balances[msg.sender] += msg.value;
        emit Deposited(msg.sender, msg.value);
    }
}

/* 2. Crea un contrato llamado RecibirEtherReceive. Este contrato tendrá un mapping llamado
balances, que mapeará una dirección a una cantidad. El contrato deberá tener una función
receive() que sirva para recibir ether. Cuando se reciba el ether, el evento Deposited(address
depositor, uint256 amount) tendrá que lanzarse, y el mapping balances deberá actualizarse,
haciendo que la cantidad enviada por el usuario se actualice en el mapping. También deberán
existir tres funciones para poder retirar el dinero: withdrawWithCall() (que permitirá transferir el
ether al usuario utilizando call()), withdrawWithTransfer() (que permitirá transferir el ether al
usuario utilizando transfer()) y withdrawWithSend() (que permitirá transferir el ether al usuario
utilizando send()). Las tres funciones deberán comprobar que quien intenta retirar el ether tenga
un balance suficiente*/
