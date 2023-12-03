
// SPDX-License-Identifier: UNLICENSED
pragma solidity = 0.8.21;

import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol";
//import "../lib/openzeppelin-contracts/contracts/token/ERC721/extensions/IERC721Metadata.sol";
/*
Token ERC721-ERC1155: Crea un token ERC721 o ERC1155 (elige uno de los dos!). A
diferencia del ejercicio sobre el ERC20, en este ejercicio no utilizaremos plantillas, ya que
se trata de que tú crees la implementación de uno de estos tokens desde cero.
a.  Puedes darle el nombre, símbolo y URI que prefieras!
b.  El token deberá mintear un token con ID 1 al creador del contrato
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
/*interface ERC721Metadata{
    function name() external view returns (string _name);
    function symbol() external view returns (string _symbol);
    function tokenURI(uint256 _tokenId) external view returns (string);
}*/

contract MiERC721 is IERC721Metadata, IERC721Enumerable{
    string public _name;
    string public _symbol;
    //uint256 tokenId; //??
    
    struct TokenMetadata{
        string name;
        string description;
        string imageUrl;
    }
    mapping (uint256 => TokenMetadata) private _tokenMetadata;

    mapping (address => uint256) private balance;
    mapping (uint256 => address) private owner;
    mapping (address => mapping(address => uint256)) private _tokenApprovals;
    mapping (address => mapping(address => bool)) private approvalForAll;
    mapping (uint256 => address) private approved;

    event Transfer (address indexed _from, address indexed _to, uint256 indexed _tokenId);
    event Approval (address indexed _owner, address indexed _approved, uint256 indexed _tokenId);
    event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);

    constructor (string memory name_, string memory symbol_){
        _name = name_;
        _symbol = symbol_;
        _tokenMetadata = TokenMetadata("FutureGarden", "El futuro crece desde el centro de la tierra => Una coleccion de fotografias de la naturaleza retocadas artisticamente");
    }

    function setTokenMetadata(uint256 tokenId, string memory name, string memory description) public {
        _tokenMetadata[tokenId] = TokenMetadata(name, description);
}


    function tokenURI(uint256 tokenId) public view virtual returns (string memory) {
        string memory baseURI = _baseURI();
        return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString(),".jpg"))
       : "";
}

    function _baseURI() internal view virtual returns (string memory) {
        return "https://ipfs.io/ipfs/QmSz8cySmzuCc57j6LZRR3bVGGfiXaQY9XFnxKTkP2x981/FutureGarden_";
    }


    function approve(address _approved, uint256 _tokenId) public{
        require(owner[_tokenId] == msg.sender, "No eres el poseedor");
        _tokenApprovals[msg.sender][_approved] = _tokenId;
        approved[_tokenId] = msg.sender;
        emit Approval(msg.sender, _approved, _tokenId);
    }

    function setApprovalForAll(address _operator, bool _approved) external{
        require(msg.sender != address(0));
        //address _owner = msg.sender;
        approvalForAll[msg.sender][_operator] = _approved;
        emit ApprovalForAll(msg.sender, _operator, _approved);
    }

    function getApproved(uint256 _tokenId) public view returns(address){
        return approved[_tokenId];            
    }

    function isApprovedForAll(address _owner, address _operator) external view returns(bool){
        return approvalForAll[_owner][_operator];
    }


    function transferFrom(address _from, address _to, uint256 _tokenId) external payable{
        require(_to != address(0), "No puede ser la direccion 0");
        if (msg.sender == _from){
            transfer(_from, _to, _tokenId);
        }else{
        require(owner[_tokenId] == _from, "No eres el poseedor del NFT");
            require(_tokenApprovals[_from][msg.sender] == _tokenId, "No tienes permiso");
            transfer(_from, _to, _tokenId);
        }
    }
        function transfer(address _from, address _to, uint256 _tokenId) internal{
            balance[_from] -= 1;
            owner[_tokenId] = _to; 
            balance[_to] += 1;
            delete _tokenApprovals[_from][msg.sender]; //¿Esto es asi????
            emit Transfer(_from, _to, _tokenId);
        }

      

    function safeTransferFrom(address _from, address _to, uint256 _tokenId) external payable{
        safeTransferFrom(_from, _to, _tokenId, "");
       
    }
    function safeTransferFrom(address _from, address _to, uint256 _tokenId,bytes calldata _data ) external payable{
        //_checkOnERC721Received(_from, _to, _tokenId, _data);
        transferFrom(_from, _to, _tokenId);
    }

    function balanceOf(address _owner) external view returns(uint256){
        return balance[_owner];
    }

    function ownerOf(uint256 _tokenId) external view returns(address){
        return owner[_tokenId];
    }

    function mint(address _to, uint256 _tokenId) internal {
        require(_to != address(0), "La direccion no puede ser 0");
        //require(_tokenId !> , "El NFT ya existe");
        balance[_to] += 1;
        owner[_tokenId] = _to;
        emit Transfer(address(0), _to, _tokenId);   
    }

    function burn(uint256 _tokenId) external {
        //require (exists(_tokenId), "El NFT no existe");
        require (owner[_tokenId] = msg.sender);
        balance[msg.sender] -= 1;
        delete owner[_tokenId];
        emit Transfer(msg.sender, address(0), _tokenId);
    }
    
    function onERC721Received(address, address, uint256, bytes calldata) external pure returns (bytes4) {
        return IERC721Receiver.onERC721Received.selector;
    }

/*
    function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory data) private {
        if (to.code.length > 0) {
            try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, data) returns (bytes4 retval) {
                if (retval != IERC721Receiver.onERC721Received.selector) {
                    revert ERC721InvalidReceiver(to);
                }
            } catch (bytes memory reason) {
                if (reason.length == 0) {
                    revert ERC721InvalidReceiver(to);
                } else {
                    /// @solidity memory-safe-assembly
                    assembly {
                        revert(add(32, reason), mload(reason))
                    }
                }
            }
        }
    } */
}