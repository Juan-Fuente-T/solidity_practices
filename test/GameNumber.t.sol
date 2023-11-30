// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console, console2} from "lib/forge-std/src/Test.sol";
import {GameNumber} from "../src/GameNumber.sol";

contract GameNumberTest is Test {
    GameNumber public gameNumber;
    address alice;
    address bob;


    //string MAINNET_RPC_URL = 'https://eth-mainnet.g.alchemy.com/v2/x285eIv7gcffbvHwtnxjDVz6kIgwvuw3';
    //uint256 mainnetFork;

    function setUp() public {
        //mainnetFork = vm.createFork(MAINNET_RPC_URL);
        vm.deal(address(this), 5 ether);
        alice = makeAddr("alice");
        //bob= makeAddr("bob");
        vm.deal(alice, 10 ether);
        vm.startPrank(alice);
        gameNumber = new GameNumber(2 ether, 1 ether, 5 ether);
        gameNumber.startNewGame();
        
    }


    function testMakeGuess() public {
        gameNumber.makeGuess{value: 1 ether}(7);
        console.log("Player guessed 7");
        assertEq(gameNumber.ethSupply(), 6 ether);
    }


    function testClaimReward() public {
        console2.log("Balance Alice", alice.balance);
        uint256 targetNumber = gameNumber.getTargetNumber();
        gameNumber.makeGuess{value: gameNumber.bet()}(targetNumber);
        assertEq(gameNumber.winner(), alice);
        console2.log("Balance Alice", alice.balance);
        assertEq(alice.balance, 9 ether);
        console2.log("AddressAlice", alice);
        console2.log("Winner", gameNumber.winner());
        console2.log("Supply", gameNumber.ethSupply());
        gameNumber.claimReward();
        console2.log("Bet", gameNumber.bet());
        console2.log("Reward", gameNumber.reward());
        assertEq(alice.balance, 11*1e18);
    }

/*
    function testGetTargetNumber() public view returns(uint256){

        uint256 targetNumber = gameNumber.getTargetNumber();

        assertEq(targetNumber, 7);

        return targetNumber;

    }*/

    function testStartNewGame() public {

        gameNumber.startNewGame();

        console.log("Start new game");

    }


    /*function testMakeGuess() public {

        gameNumber.makeGuess(7);

        console.log("Player guessed 7");

    }


    function testClaimReward() public {

        gameNumber.claimReward();

        console.log("Reward claimed");

    }*/

    
}