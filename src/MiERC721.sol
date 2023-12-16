// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.21;

import "lib/openzeppelin-contracts/contracts/token/ERC721/IERC721Receiver.sol";
import "lib/openzeppelin-contracts/contracts/token/ERC721/extensions/IERC721Metadata.sol";
import "lib/openzeppelin-contracts/contracts/token/ERC721/extensions/IERC721Enumerable.sol";
import "lib/openzeppelin-contracts/contracts/utils/Strings.sol";
import {console} from "../lib/forge-std/src/console.sol";

/*
Token ERC721-ERC1155: Crea un token ERC721 o ERC1155 (elige uno de los dos!). A
diferencia del ejercicio sobre el ERC20, en este ejercicio no utilizaremos plantillas, ya que
se trata de que tú crees la implementación de uno de estos tokens desde cero.
a.  Puedes darle el nombre, símbolo y URI que prefieras!
b.  El token deberá mintear un token con ID 1 al creador del contrato

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

contract MiERC721 {
    /*is IERC721Metadata, IERC721Enumerable*/
    using Strings for uint256;

    address public creator;
    string public _name;
    string public _symbol;
    string private _defaultName = "FutureGarden";
    string private _defaultDescription =
        "El futuro crece desde el centro de la tierra => Una coleccion de fotografias de la naturaleza retocadas artisticamente";

    struct TokenMetadata {
        string name;
        string description;
        string imageUrl;
    }

    mapping(uint256 => TokenMetadata) private _tokenMetadata;

    mapping(address => uint256) private balance;
    mapping(uint256 => address) private owner;
    mapping(address => mapping(address => uint256)) private _tokenApprovals;
    mapping(address => mapping(address => bool)) private approvalForAll;
    mapping(uint256 => address) private approved;

    event Deploy(address indexed creator);
    event Mint(address indexed to, uint256 _tokenId);
    event Burn(uint256 _tokenId);
    event Transfer(
        address indexed _from,
        address indexed _to,
        uint256 indexed _tokenId
    );
    event Approval(
        address indexed _owner,
        address indexed _approved,
        uint256 indexed _tokenId
    );
    event ApprovalForAll(
        address indexed _owner,
        address indexed _operator,
        bool _approved
    );

    constructor(string memory name_, string memory symbol_) {
        creator = msg.sender;
        _name = name_;
        _symbol = symbol_;
        mint(address(this), 1);
        emit Deploy(creator);
    }

    function setTokenMetadata(uint256 tokenId) public {
        _tokenMetadata[tokenId] = TokenMetadata(
            _defaultName,
            _defaultDescription,
            tokenURI(tokenId)
        );
    }

    function tokenURI(uint256 tokenId) public view returns (string memory) {
        string memory baseURI = _baseURI();
        return
            bytes(baseURI).length > 0
                ? string(
                    abi.encodePacked(
                        _tokenMetadata[tokenId].name,
                        _tokenMetadata[tokenId].description,
                        baseURI,
                        tokenId.toString(),
                        ".jpg"
                    )
                )
                : "";
    }

    function _baseURI() internal pure returns (string memory) {
        return
            "https://ipfs.io/ipfs/QmSz8cySmzuCc57j6LZRR3bVGGfiXaQY9XFnxKTkP2x981/FutureGarden_";
    }

    function approve(address _approved, uint256 _tokenId) public {
        require(owner[_tokenId] == msg.sender, "No eres el poseedor del NFT");
        _tokenApprovals[msg.sender][_approved] = _tokenId;
        approved[_tokenId] = _approved;
        emit Approval(msg.sender, _approved, _tokenId);
    }

    function setApprovalForAll(address _operator, bool _approved) external {
        //require(msg.sender != address(0)); NO ES NECESARTIO la address(0) no puede ejecutar transacciones
        //address _owner = msg.sender;
        approvalForAll[msg.sender][_operator] = _approved;
        emit ApprovalForAll(msg.sender, _operator, _approved);
    }

    function getApproved(uint256 _tokenId) public view returns (address) {
        return approved[_tokenId];
    }

    function isApprovedForAll(
        address _owner,
        address _operator
    ) external view returns (bool) {
        return approvalForAll[_owner][_operator];
    }

    function transferFrom(
        address _from,
        address _to,
        uint256 _tokenId
    ) public payable {
        require(_to != address(0), "No puede ser la direccion 0");
        require(owner[_tokenId] == _from, "No eres el poseedor del NFT");
        if (msg.sender == _from) {
            transfer(_from, _to, _tokenId);
        } else {
            //Esto está bien??
            //require(owner[_tokenId] == _from, "No eres el poseedor del NFT");
            require(
                _tokenApprovals[_from][msg.sender] == _tokenId ||
                    approvalForAll[_from][msg.sender],
                "No tienes permiso"
            );
            transfer(_from, _to, _tokenId);
        }
    }

    function transfer(address _from, address _to, uint256 _tokenId) internal {
        balance[_from] -= 1;
        owner[_tokenId] = _to;
        balance[_to] += 1;
        delete _tokenApprovals[_from][msg.sender]; //¿Esto es asi????
        emit Transfer(_from, _to, _tokenId);
    }

    function safeTransferFrom(
        address _from,
        address _to,
        uint256 _tokenId
    ) public payable {
        console.log("Inicio funcion safeTransferfrom");
        //safeTransferFrom(_from, _to, _tokenId, "");
        //if(_to.onERC721Received()){
        //transferFrom(_from, _to, _tokenId);}

        // Se llama a onERC721Received en el contrato de destino
        bytes4 retval = IERC721Receiver(_to).onERC721Received(
            _from,
            _to,
            _tokenId,
            ""
        );
        console.logBytes4(retval);
        // Se verifica que onERC721Received devolvió el valor correcto
        require(
            retval ==
                bytes4(
                    keccak256("onERC721Received(address,address,uint256,bytes)")
                ),
            "No es posible enviar el NFT"
        );
        console.log(_from, _to, _tokenId);
        // Si todo está bien, se realiza la transferencia
        transferFrom(_from, _to, _tokenId);
    }

    function safeTransferFrom(
        address _from,
        address _to,
        uint256 _tokenId,
        bytes calldata _data
    ) external payable {
        // Se llama a onERC721Received en el contrato de destino
        bytes4 retval = IERC721Receiver(_to).onERC721Received(
            _from,
            _to,
            _tokenId,
            _data
        );
        // Se verifica que onERC721Received devolvió el valor correcto
        require(
            retval ==
                bytes4(
                    keccak256("onERC721Received(address,address,uint256,bytes)")
                ),
            "No es posible enviar el NFT"
        );
        // Si todo está bien, se realiza la transferencia
        safeTransferFrom(_from, _to, _tokenId);
    }

    function balanceOf(address _owner) external view returns (uint256) {
        return balance[_owner];
    }

    function ownerOf(uint256 _tokenId) external view returns (address) {
        return owner[_tokenId];
    }

    function mint(address _to, uint256 _tokenId) public {
        require(_to != address(0), "La direccion no puede ser 0");
        //require(_tokenId !> , "El NFT ya existe");
        balance[_to] += 1;
        owner[_tokenId] = _to;
        emit Mint(_to, _tokenId);
    }

    function burn(uint256 _tokenId) external {
        //require (exists(_tokenId), "El NFT no existe");
        require(owner[_tokenId] == msg.sender, "No eres poseedor de ese NFT");
        balance[msg.sender] -= 1;
        owner[_tokenId] = address(0x0);
        emit Burn(_tokenId);
    }

    function onERC721Received(
        address,
        address,
        uint256,
        bytes calldata
    ) external pure returns (bytes4) {
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
