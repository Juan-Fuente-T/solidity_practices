// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;
import {Test, console2} from "lib/forge-std/src/Test.sol";
import "lib/forge-std/src/console.sol";
import {MiDAO} from "../src/MiDAO.sol";

contract MiDAOest is Test{
    MiDAO public miDAO;
    address alice;
    address bob;

    //string MAINNET_RPC_URL = 'https://eth-mainnet.g.alchemy.com/v2/x285eIv7gcffbvHwtnxjDVz6kIgwvuw3';
    //uint256 mainnetFork;

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


    function setUp() public {
        //mainnetFork = vm.createFork(MAINNET_RPC_URL);
        alice = makeAddr("alice");
        bob = makeAddr("bob");
        //vm.deal(alice, 10 ether);
        vm.startPrank(alice);
        miDAO = new MiDAO();
    }


    function testCrearPropuesta() public {
        miDAO.crearPropuesta("Crear DAO", "0x1234");
        console2.log("NumPropuestas", miDAO.numPropuestas());      
        assertEq(miDAO.numPropuestas(), 1);
        (address creador,string memory descripcion, , , , bytes memory transaction, ) = miDAO.propuestas(0);
        //address creador = miDAO.propuestas(0).creador;
        console2.log("Creador",creador);
        console2.log("Descripcion", descripcion);
        console.logBytes(transaction);
        assertEq(alice, creador);
        assertEq(descripcion, "Crear DAO");
        assertEq(transaction, "0x1234");
    }
    function testVotarPropuesta() public {
        miDAO.crearPropuesta("Crear DAO", "0x1234");
        console2.log("NumPropuestas", miDAO.numPropuestas());      
        assertEq(miDAO.numPropuestas(), 1);
        miDAO.votarPropuesta(0, 1);
        vm.stopPrank();
        vm.startPrank(bob);
        miDAO.votarPropuesta(0, 0);
        ( , , uint256 votos_si, uint256 votos_no, uint256 votos_blanco, , bool votado) = miDAO.propuestas(0);
        //bool votadoX = miDAO.propuestas(0).votado[msg.sender];
        console2.log("VotosSI",votos_si);
        console2.log("VotosNo", votos_no);
        console2.log("VotosBlanco", votos_blanco);
        //console.log("Votado", votadoX);
        //console.log(miDAO.propuesta.votado);
        assertGt(votos_si, 0);
        assertEq(1, votos_si);
        assertEq(1, votos_no);
        assertEq(0, votos_blanco);
        assertTrue(votado);
        vm.expectRevert(bytes("Ya has votado antes"));
        miDAO.votarPropuesta(0, 2);
    }

}