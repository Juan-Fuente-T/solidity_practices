// SPDX-License-Identifier: UNLICENSED
pragma solidity = 0.8.21;

import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
//import "../lib/openzeppelin-contracts/contracts/token/ERC721/extensions/IERC721Metadata.sol";

//https://eips.ethereum.org/EIPS/eip-1155
/*
interface ERC1155 /* is ERC165 */ {
    /**      
    
    event TransferSingle(address indexed _operator, address indexed _from, address indexed _to, uint256 _id, uint256 _value);

    event TransferBatch(address indexed _operator, address indexed _from, address indexed _to, uint256[] _ids, uint256[] _values);

    event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
    
        @dev MUST emit when the URI is updated for a token ID.
        URIs are defined in RFC 3986.
        The URI MUST point to a JSON file that conforms to the "ERC-1155 Metadata URI JSON Schema".
    
    event URI(string _value, uint256 indexed _id);
}*/

/**
 
        @param _data    Additional data with no specified format, MUST be sent unaltered in call to `onERC1155Received` on `_to`
    

    /**
    function safeTransferFrom(address _from, address _to, uint256 _id, uint256 _value, bytes calldata _data) external;

        @notice Transfers `_values` amount(s) of `_ids` from the `_from` address to the `_to` address specified (with safety call).
        @dev Caller must be approved to manage the tokens being transferred out of the `_from` account (see "Approval" section of the standard).
        MUST revert if `_to` is the zero address.
        MUST revert if length of `_ids` is not the same as length of `_values`.
        MUST revert if any of the balance(s) of the holder(s) for token(s) in `_ids` is lower than the respective amount(s) in `_values` sent to the recipient.
        MUST revert on any other error.        
        MUST emit `TransferSingle` or `TransferBatch` event(s) such that all the balance changes are reflected (see "Safe Transfer Rules" section of the standard).
        Balance changes and events MUST follow the ordering of the arrays (_ids[0]/_values[0] before _ids[1]/_values[1], etc).
        After the above conditions for the transfer(s) in the batch are met, this function MUST check if `_to` is a smart contract (e.g. code size > 0). If so, it MUST call the relevant `ERC1155TokenReceiver` hook(s) on `_to` and act appropriately (see "Safe Transfer Rules" section of the standard).                      
        @param _from    Source address
        @param _to      Target address
        @param _ids     IDs of each token type (order and length must match _values array)
        @param _values  Transfer amounts per token type (order and length must match _ids array)
        @param _data    Additional data with no specified format, MUST be sent unaltered in call to the `ERC1155TokenReceiver` hook(s) on `_to`
    */
    function safeBatchTransferFrom(address _from, address _to, uint256[] calldata _ids, uint256[] calldata _values, bytes calldata _data) external;

    /**
        @notice Get the balance of an account's tokens.
        @param _owner  The address of the token holder
        @param _id     ID of the token
        @return        The _owner's balance of the token type requested
     */
    function balanceOf(address _owner, uint256 _id) external view returns (uint256);

    /**
        @notice Get the balance of multiple account/token pairs
        @param _owners The addresses of the token holders
        @param _ids    ID of the tokens
        @return        The _owner's balance of the token types requested (i.e. balance for each (owner, id) pair)
     */
    function balanceOfBatch(address[] calldata _owners, uint256[] calldata _ids) external view returns (uint256[] memory);

    /**
        @notice Enable or disable approval for a third party ("operator") to manage all of the caller's tokens.
        @dev MUST emit the ApprovalForAll event on success.
        @param _operator  Address to add to the set of authorized operators
        @param _approved  True if the operator is approved, false to revoke approval
    */
    function setApprovalForAll(address _operator, bool _approved) external;

    /**
        @notice Queries the approval status of an operator for a given owner.
        @param _owner     The owner of the tokens
        @param _operator  Address of authorized operator
        @return           True if the operator is approved, false if not
    */
    function isApprovedForAll(address _owner, address _operator) external view returns (bool);
}


contract MiERC721 /*is IERC721Metadata, IERC721Enumerable*/{
    using Strings for uint256;

    string public _name;
    string public _symbol;
    string private _defaultName = "FutureGarden";
    string private _defaultDescription = "El futuro crece desde el centro de la tierra => Una coleccion de fotografias de la naturaleza retocadas artisticamente";
    
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

    event Deploy(address indexed creator);
    event Mint(address indexed to, uint256 _tokenId);
    event Burn(uint256 _tokenId);
    event Transfer (address indexed _from, address indexed _to, uint256 indexed _tokenId);
    event Approval (address indexed _owner, address indexed _approved, uint256 indexed _tokenId);
    event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);

    constructor (string memory name_, string memory symbol_){
        _name = name_;
        _symbol = symbol_;
        mint(address(this), 1);
        emit Deploy(msg.sender);
    }

   function setTokenMetadata(uint256 tokenId) public {
         _tokenMetadata[tokenId] = TokenMetadata(_defaultName, _defaultDescription, tokenURI(tokenId));
}


    function tokenURI(uint256 tokenId) public view  returns (string memory) {
        string memory baseURI = _baseURI();
        return bytes(baseURI).length > 0 ? string(abi.encodePacked(_tokenMetadata[tokenId].name,_tokenMetadata[tokenId].description ,baseURI, tokenId.toString(),".jpg"))
       : "";
}

    function _baseURI() internal pure returns (string memory) {
        return "https://ipfs.io/ipfs/QmSz8cySmzuCc57j6LZRR3bVGGfiXaQY9XFnxKTkP2x981/FutureGarden_";
    }


    function approve(address _approved, uint256 _tokenId) public{
        require(owner[_tokenId] == msg.sender, "No eres el poseedor del NFT");
        _tokenApprovals[msg.sender][_approved] = _tokenId;
        approved[_tokenId] = _approved;
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


    function transferFrom(address _from, address _to, uint256 _tokenId) public payable{
        require(_to != address(0), "No puede ser la direccion 0");
        require(owner[_tokenId] == _from, "No eres el poseedor del NFT");
        if (msg.sender == _from){
            transfer(_from, _to, _tokenId);
        }else{
            //Esto está bien??
            //require(owner[_tokenId] == _from, "No eres el poseedor del NFT");
            require(_tokenApprovals[_from][msg.sender] == _tokenId || approvalForAll[_from][msg.sender], "No tienes permiso");
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
        //safeTransferFrom(_from, _to, _tokenId, "");
        //if(_to.onERC721Received()){
        //transferFrom(_from, _to, _tokenId);}  
        
        // Se llama a onERC721Received en el contrato de destino
        bytes4 retval = IERC721Receiver(_to).onERC721Received(msg.sender, _from, _tokenId, "");
        // Se verifica que onERC721Received devolvió el valor correcto
        require(retval == bytes4(keccak256("onERC721Received(address,address,uint256,bytes)")), "No es posible enviar el NFT");
        // Si todo está bien, se realiza la transferencia
        transferFrom(_from, _to, _tokenId);
    }
    function safeTransferFrom(address _from, address _to, uint256 _tokenId,bytes calldata _data ) external payable{
        // Se llama a onERC721Received en el contrato de destino
        bytes4 retval = IERC721Receiver(_to).onERC721Received(msg.sender, _from, _tokenId, _data);
        // Se verifica que onERC721Received devolvió el valor correcto
        require(retval == bytes4(keccak256("onERC721Received(address,address,uint256,bytes)")), "No es posible enviar el NFT");
        // Si todo está bien, se realiza la transferencia
        transferFrom(_from, _to, _tokenId);
    }

    function balanceOf(address _owner) external view returns(uint256){
        return balance[_owner];
    }

    function ownerOf(uint256 _tokenId) external view returns(address){
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
        emit Burn( _tokenId);
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