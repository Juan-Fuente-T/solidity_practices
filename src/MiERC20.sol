/*
Ejercicios Solidity - ERC20
Codingheroes
1. Token ERC20: Crea un token ERC20 utilizando una plantilla (puedes utilizar tanto la
plantilla de OpenZeppelin como la de Solmate):
a. Puedes darle el nombre y símbolo que más te guste!
b. El token deberá mintear 1 millón de tokens al creador del contrato (msg.sender)
cuando tu contrato sea deployado, y emitir un evento llamado Genesis, con la
dirección del creador como parámetro
c. Tu contrato deberá incluir una función pública llamada mint(address to, uint256
amount), que permita mintear una cantidad amount a una dirección to pasadas por
parámetro (la dirección to no podrá ser address(0), y la cantidad amount no podrá ser
0), y otra función pública llamada burn(uint256 amount), que permita quemar una
cantidad amount de la dirección que llame a la función burn() (la cantidad amount no
podrá ser 0). Ambas funciones deberán emitir un evento Mint(address to, uint256
amount) y Burn(uint256 amount) respectivamente.
d. Deberás crear los siguientes tests:
i. testDeploy(): test que permitirá comprobar que después de hacer el deployment la
el creador del contrato efectivamente ha recibido 1 millón de tokens
ii. testMint(): test que permitirá comprobar que al llamar la función pública mint() la
dirección to recibe correctamente la cantidad de tokens amount. También deberá
comprobar que al pasar una dirección 0 o una cantidad de tokens 0, el contrato
lanza un error
iii. testBurn(): test que permitirá comprobar que al llamar la función pública burn() los
tokens de la dirección to son quemados correctamente con la cantidad de tokens
amount. También deberá comprobar que al pasar una cantidad de tokens 0, el
contrato lanza un error
iv. Todos los tests deberán comprobar que los eventos de las funciones se emiten
correctamente utilizando expectEmit(
*/
// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

contract MiERC20 {
    address public creator;
    string public name;
    string public symbol;
    uint256 public decimals;

    event Genesis(address indexed creator);
    event Mint(address indexed to, uint256 amount);
    event Burn(uint256 amount);
    event Transfer(address indexed from, address indexed to, uint256 amount);
    event TransferFrom(
        address indexed from,
        address indexed to,
        uint256 amount
    );
    event Approval(
        address indexed sender,
        address indexed approved,
        uint256 amount
    );

    uint256 public totalSupply;
    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;

    constructor(string memory _name, string memory _symbol, uint256 _decimals) {
        name = _name;
        symbol = _symbol;
        decimals = _decimals;
        creator = msg.sender;
        balanceOf[creator] += 1000000 * 10 ** _decimals;
        totalSupply += 1000000 * 10 ** _decimals;
        emit Genesis(creator);
    }

    function transfer(address to, uint256 amount) external returns (bool) {
        require(to != address(0), "La direccion de destino no puede ser 0");
        require(
            amount > 0 && balanceOf[msg.sender] >= amount,
            "Error en transferencia"
        );
        balanceOf[msg.sender] -= amount;
        balanceOf[to] += amount;
        emit Transfer(msg.sender, to, amount);
        return true;
    }

    function approve(address spender, uint256 amount) external returns (bool) {
        allowance[msg.sender][spender] += amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    //en transferFrom actuan tres elementos, el que quiere enviar(from), el que va a recibir(to) y el que va a ejecutar el envio(msg.sender)

    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) external returns (bool) {
        require(
            amount > 0 && balanceOf[from] >= amount,
            "Error en transferencia"
        );
        require(
            from != address(0) && to != address(0),
            "La direccion no puede ser 0"
        );
        if (msg.sender != from) {
            require(allowance[from][msg.sender] >= amount);
            allowance[from][msg.sender] -= amount;
        }
        balanceOf[from] -= amount;
        balanceOf[to] += amount;
        emit TransferFrom(from, to, amount);
        return true;
    }

    function mint(address to, uint256 amount) public {
        require(to != address(0), "Address can't be 0");
        require(amount > 0, "Amount is not enough");
        balanceOf[to] += amount;
        totalSupply += amount;
        emit Mint(to, amount);
    }

    function burn(uint256 amount) public {
        require(amount > 0, "Amount is not enough");
        balanceOf[msg.sender] -= amount;
        totalSupply -= amount;
        balanceOf[address(0)] += amount;
        emit Burn(amount);
    }
}
