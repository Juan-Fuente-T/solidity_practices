// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.19;

interface IPayload {
    function execute() external;
}
 

contract MiDAO{
    struct Propuesta{
        address creador;
        string descripcion;
        uint256 votos_si;
        uint256 votos_no;
        uint256 votos_blanco;
        bytes transaction;
        //mapping de una direccion a un booleano de si/no han votado
        mapping (address => bool) votado;
        bool ejecutado;
    }

    //error YaHasVotado();

    mapping (uint256 => Propuesta) public propuestas;
    uint256 public numPropuestas;

    function crearPropuesta(string calldata description, bytes calldata transaction) public {

        Propuesta storage propuesta = propuestas[numPropuestas];

        propuesta.creador = msg.sender;
        propuesta.descripcion = description;
        propuesta.transaction = transaction;

        numPropuestas ++;
    }
     function votarPropuesta(uint256 id, uint256 voto) public{
         Propuesta storage propuesta = propuestas[id];

         /*if (propuesta.votado[msg.sender]){
             revert YaHasVotado();*/
        require(msg.sender != address(0), "Can't be address 0");
        require(!propuesta.votado[msg.sender], "Ya has votado antes");
        require(voto < 3, "Voto incorrecto!");

        if (voto == 0){
            propuesta.votos_si ++;
        }else if (voto == 1){
            propuesta.votos_no ++;
        }else if (voto == 2){
            propuesta.votos_blanco ++;
        }
        
        propuesta.votado[msg.sender] = true;

     }

     function ejecutarTrasaccion(uint256 id) public{
        Propuesta storage propuesta = propuestas[id];
        
        require (!propuesta.ejecutado, "Esta propuesta ya ha sido ejecutada");
        require (propuesta.votos_si > propuesta.votos_no * 2, "Votos insuficientes!");

        // Ejecutar la propuesra, realmente habria que hacer Delegate call en lugar de llamar a la función
        //IPayload(propuesta.payload).execute();//se envuelve la direccion de payload en la interface y se llama a execute()
        //se da valor ejecutado positivo a la propuesta
        propuesta.ejecutado = true;
    }
        /*
        Lógica de ejecucion de la propuesta, que está gurdada en el campo transacción en propuesta.trasaccion.¿?
        */



}