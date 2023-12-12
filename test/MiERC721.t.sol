// SPDX-License-Identifier: UNLICENSED
pragma solidity = 0.8.21;

import {Test, console2} from "lib/forge-std/src/Test.sol";
import {MiERC721} from "../src/MiERC721.sol";

/*
c.  Para los tests, deberás pensar qué funciones necesitarás para probar la funcionalidad
de _todo contrato. El reto de este ejercicio consiste en intentar testear al máximo tu
contrato, sin dejar ningún cabo suelto. Recuerda que puedes utilizar recursos
parecidos a los utilizados en el ejercicio de ER20, tales como:
i.  Testear los casos donde el contrato debería revertir, utilizando vm.expectRequire()
ii.  Comprobando que los errores se emiten de forma correcta utilizando
vm.expectEmit()
iii.  Creando un test para cada función de nuestro contrato. Por ejemplo, si nuestro
contrato tiene una función mint(), una función transferFrom() y una función
safeTransferFrom(), deberás tener los siguientes tests:
1.  testDeploy() (Este test nos servirá para comprobar que el constructir mintea el
token con ID 1 al creador del contrato!)
2.  testMint()
3.  testTransferFrom()
4.  testSafeTransferFrom()
*/
/*
    function balanceOf(address _owner) external view returns (uint256);
    function ownerOf(uint256 _tokenId) external view returns (address);
    function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes data) external payable;
    function safeTransferFrom(address _from, address _to, uint256 _tokenId) external payable;
    function transferFrom(address _from, address _to, uint256 _tokenId) external payable;
    function approve(address _approved, uint256 _tokenId) external payable;
    function setApprovalForAll(address _operator, bool _approved) external;
    function getApproved(uint256 _tokenId) external view returns (address);
    function isApprovedForAll(address _owner, address _operator) external view returns (bool);
*/

contract MiERC20Test is Test {
    MiERC721 public miERC721;
    address alice;
    address bob;
    address carol;

    event Deploy(address indexed creator);
    event Mint(address indexed to, uint256 _tokenId);
    event Burn(uint256 _tokenId);
    event Transfer(address indexed _from, address indexed _to, uint256 indexed _tokenId);
    event Approval(address indexed _owner, address indexed _approved, uint256 indexed _tokenId);
    event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);

    function setUp() public {
        miERC721 = new MiERC721("MiERC721", "ME721");
        alice = makeAddr("alice");
        bob = makeAddr("bob");
        carol = makeAddr("carol");
        vm.startPrank(alice);
    }

    function testTokenURI() public view {
        console2.log("URI", miERC721.tokenURI(1));
    }

    function testDeploy() public {
        vm.expectEmit();
        emit Deploy(alice);
        assertEq(miERC721.balanceOf(address(miERC721)), 1);
        assertEq(miERC721.ownerOf(1), address(miERC721));
        assertEq(miERC721.getApproved(1), address(0x0));
        assertEq(miERC721.isApprovedForAll(msg.sender, msg.sender), false);
        assertEq(miERC721._name(), string("MiERC721"));
        assertEq(miERC721._symbol(), string("ME721"));
        console2.log("URI", miERC721.tokenURI(1));
    }

    function testMint() public {
        vm.expectEmit(true, false, false, false);
        emit Mint(alice, 2);
        miERC721.mint(alice, 2);
        miERC721.mint(msg.sender, 3);
        console2.log("Balance alice:", miERC721.balanceOf(alice));
        assertEq(miERC721.balanceOf(alice), 1);
        assertEq(miERC721.balanceOf(msg.sender), 1);
        assertEq(miERC721.ownerOf(2), alice);
        assertEq(miERC721.ownerOf(3), msg.sender);
        vm.expectRevert("La direccion no puede ser 0");
        miERC721.mint(address(0), 4);
    }

    function testBurn() public {
        miERC721.mint(alice, 2);
        miERC721.mint(msg.sender, 3);
        console2.log("Balance alice:", miERC721.balanceOf(alice));
        assertEq(miERC721.balanceOf(alice), 1);
        assertEq(miERC721.balanceOf(msg.sender), 1);
        console2.log("Owner of NFT 2", miERC721.ownerOf(2));
        assertEq(miERC721.ownerOf(2), alice);
        assertEq(miERC721.ownerOf(3), address(msg.sender));
        vm.expectRevert("No eres poseedor de ese NFT");
        miERC721.burn(3);
        console2.log("Owner of NFT 3", miERC721.ownerOf(3));
        vm.expectEmit(true, false, false, false);
        emit Burn(2);
        miERC721.burn(2);
        assertEq(miERC721.ownerOf(2), address(0));
        //assertNotEq(miERC721.ownerOf(2), address(alice));
        console2.log("Owner of NFT 2", miERC721.ownerOf(2));
    }

    function testTransferFrom() public {
        miERC721.mint(alice, 2);
        assertEq(miERC721.ownerOf(2), alice);
        vm.expectRevert("No puede ser la direccion 0");
        miERC721.transferFrom(alice, address(0), 2);
        vm.expectEmit();
        emit Transfer(alice, bob, 2);
        miERC721.transferFrom(alice, bob, 2);
        assertEq(miERC721.ownerOf(2), bob);
        vm.expectRevert("No eres el poseedor del NFT");
        miERC721.transferFrom(alice, bob, 1);
        vm.startPrank(bob);
        miERC721.mint(bob, 3);
        console2.log(msg.sender);
        miERC721.transferFrom(bob, carol, 3);
        assertEq(miERC721.ownerOf(3), carol);
        vm.startPrank(carol);
        miERC721.transferFrom(carol, bob, 3);
        assertEq(miERC721.ownerOf(3), bob);
        //Falla saveTransferFrom()
        //miERC721.safeTransferFrom(msg.sender, bob, 3);
        //vm.expectRevert("No eres el poseedor del NFT");
        //vm.expectRevert("No eres el poseedor del NFT");
        //miERC721.safeTransferFrom(msg.sender, bob, 3);
    }

    function testApproval() public {
        miERC721.mint(alice, 2);
        miERC721.mint(msg.sender, 3);
        vm.expectEmit();
        emit Approval(alice, carol, 2);
        miERC721.approve(carol, 2);
        vm.startPrank(bob);
        vm.expectRevert("No tienes permiso");
        miERC721.transferFrom(alice, bob, 2);
        vm.startPrank(carol);
        miERC721.transferFrom(alice, bob, 2);
        assertEq(miERC721.ownerOf(2), bob);
        miERC721.mint(carol, 3);
        miERC721.setApprovalForAll(address(miERC721), false);
        vm.expectEmit();
        emit ApprovalForAll(carol, bob, true);
        miERC721.setApprovalForAll(bob, true);
        console2.log("ApprovedForAll", miERC721.isApprovedForAll(carol, bob));
        assertEq(miERC721.ownerOf(3), carol);
        vm.startPrank(bob);
        miERC721.transferFrom(carol, alice, 3);
        assertEq(miERC721.ownerOf(3), alice);
    }

    function testSafeTransferFrom() public {
        miERC721.mint(alice, 4);
        vm.startPrank(carol);
        miERC721.safeTransferFrom(carol, bob, 4, "");
        assertEq(miERC721.ownerOf(4), bob);
        vm.startPrank(bob);
        miERC721.safeTransferFrom(bob, alice, 4, "");
        assertEq(miERC721.ownerOf(4), alice);
        vm.startPrank(alice);
        miERC721.safeTransferFrom(alice, bob, 4, "");
        assertEq(miERC721.ownerOf(4), bob);

        /*
        Orden para creacion contratos:
        Struts 
        variables
        eventos 
        errores
        funciones
        
        address alice = address(1) genera una address numero 1 para alice
        startHoax(alice)  similar al starPrank pero con fondos, la siguientes llamadas serán de alice
        */
    }
}
