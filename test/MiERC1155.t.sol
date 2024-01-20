// SPDX-License-Identifier: UNLICENSED
pragma solidity =0.8.21;

import {Test, console2} from "lib/forge-std/src/Test.sol";
import {MiERC1155} from "../src/MiERC1155.sol";
/*
contract MiERC1155Test is Test {
    MiERC1155 public miERC1155;
    address alice;
    address bob;
    address carol;

    event TransferSingle(
        address indexed _operator,
        address indexed _from,
        address indexed _to,
        uint256 _id,
        uint256 _value
    );
    event TransferBatch(
        address indexed _operator,
        address indexed _from,
        address indexed _to,
        uint256[] _ids,
        uint256[] _values
    );
    event ApprovalForAll(
        address indexed _owner,
        address indexed _operator,
        bool _approved
    );
    event URI(string _value, uint256 indexed _id);

    //event Deploy(address indexed creator);
    event Mint(address indexed to, uint256 _tokenId, uint256 _value);
    event Burn(address indexed from, uint256 _tokenId, uint256 _value);

    function setUp() public {
        miERC1155 = new MiERC1155("MiERC721", "ME721");
        alice = makeAddr("alice");
        bob = makeAddr("bob");
        carol = makeAddr("carol");
        vm.startPrank(alice);
    }

    function testMiERC1155Mint() public {
        vm.expectEmit(true, true, true, false);
        emit Mint(alice, 1, 11);
        miERC1155.mint(alice, 1, 11);
        miERC1155.mint(msg.sender, 2, 22);
        console2.log("Balance alice:", miERC1155.balance(alice, 1));
        assertEq(miERC1155.balanceOf(alice, 1), 11);
        assertEq(miERC1155.balanceOf(msg.sender, 2), 22);
        vm.expectRevert("La direccion no puede ser 0");
        miERC1155.mint(address(0), 4, 44);
    }

    function testMiERC1155Burn() public {
        //FALLA
        miERC1155.mint(alice, 1, 11);
        miERC1155.mint(msg.sender, 2, 22);
        console2.log("Balance alice:", miERC1155.balanceOf(alice, 1));
        assertEq(miERC1155.balanceOf(alice, 1), 11);
        assertEq(miERC1155.balanceOf(msg.sender, 2), 22);
        //console2.log("Owner of NFT 2", miERC721.ownerOf(2));
        assertEq(miERC1155.balanceOf(msg.sender, 2), 22);
        miERC1155.mint(alice, 3, 33);
        //(uint256[] memory balances) = erc1155.balanceOfBatch(new address[](2) [owner, owner], new uint256[](2) [id1, id2]);
        //console2.log(balances);
        /*miERC1155.balanceOfBatch([alice, alice], [1, 3]);
        console2.log(
            "BalancesAlice",
            miERC1155.balanceOfBatch([alice, alice], [1, 3])
        );
        vm.expectRevert("No eres poseedor de todos esos NFT");
        miERC1155.burn(3, 33);
        //console2.log("Owner of NFT 3", miERC721.ownerOf(3));
        console2.log("BalanceMSG.Sender2", miERC1155.balanceOf(msg.sender, 2));
        vm.expectEmit(true, true, true, false);
        emit Burn(msg.sender, 2, 11);
        miERC1155.burn(2, 11);
        //assertEq(miERC1155.ownerOf(2), address(0));
        //assertNotEq(miERC721.ownerOf(2), address(alice));
    }

    function testBalanceOfBatch() public {
        miERC1155.mint(alice, 1, 11);
        miERC1155.mint(alice, 2, 22);
        miERC1155.mint(bob, 1, 33);

        uint256[] memory owners = new uint256[](3);
        owners[0] = uint256(alice);
        owners[1] = uint256(alice);
        owners[2] = uint256(bob);

        uint256[] memory ids = new uint256[](3);
        ids[0] = 1;
        ids[1] = 2;
        ids[2] = 1;

        uint256[] memory expectedBalances = new uint256[](3);
        expectedBalances[0] = 11;
        expectedBalances[1] = 22;
        expectedBalances[2] = 33;

        uint256[] memory batchBalances = miERC1155.balanceOfBatch(owners, ids);

        assertEq(
            batchBalances.length,
            expectedBalances.length,
            "Incorrect batchBalances length"
        );

        for (uint256 i = 0; i < batchBalances.length; i++) {
            assertEq(
                batchBalances[i],
                expectedBalances[i],
                "Incorrect batch balance"
            );
        }
    }

    function testMiERC721Approval() public {
        miERC1155.mint(alice, 1, 11);
        miERC1155.mint(msg.sender, 2, 22);
        miERC1155.mint(alice, 3, 33);
        miERC1155.balanceOfBatch([alice, msg.sender, alice], [1, 2, 3]);
        vm.expectEmit();
        emit ApprovalForAll(alice, carol, true);
        miERC1155.setApprovalForAll(carol, true);
        assert(miERC1155.isApprovedForAll(alice, carol));
        vm.startPrank(bob);
        vm.expectRevert("No tienes permiso");
        miERC1155.safeTransferFrom(alice, bob, 1, 5, "");
        vm.startPrank(carol);
        miERC1155.transferSingle(alice, bob, 1, 5);
        miERC1155.mint(carol, 3);
        vm.expectEmit();
        emit ApprovalForAll(carol, address(miERC1155), true);
        miERC1155.setApprovalForAll(address(miERC1155), true);
        assertEq(miERC1155.isApprovalForAll(address(miERC1155), carol), true);
    }

    function testMiERC721ApprovalFalla() public {
        miERC1155.mint(alice, 2);
        miERC1155.mint(msg.sender, 3);
        assertEq(false, miERC1155.isApprovedForAll(carol, true));
        console2.log("ApprovedForAll", miERC1155.isApprovedForAll(carol, bob));
        vm.expectRevert("EVMRevert");
        miERC1155.setApprovalForAll(address(0), true);
        assertEq(miERC1155.ownerOf(3), alice);
        vm.expectEmit();
        emit ApprovalForAll(alice, carol, true);
        miERC1155.setApprovalForAll(carol, true);
        assert(miERC1155.isApprovedForAll(alice, carol));
        vm.startPrank(bob);
        vm.expectRevert("No tienes permiso");
        miERC1155.transferSingle(alice, bob, 1, 5);
        vm.startPrank(carol);
        miERC1155.transferSingle(alice, bob, 1, 5);
        miERC1155.mint(carol, 3);
        vm.expectEmit();
        emit ApprovalForAll(carol, address(miERC1155), true);
        miERC1155.setApprovalForAll(address(miERC1155), true);
        assertEq(miERC1155.isApprovalForAll(address(miERC1155), carol), true);
    }
}
*/
