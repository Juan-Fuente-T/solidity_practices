// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.21;

import {Test, console2} from "forge-std/Test.sol";
import {Vote} from "../src/Vote.sol";

contract CounterTest is Test {
    struct Candidate {
        string name;
        uint256 votes;
    }

    Vote public vote;

    function setUp() public {
        vote = new Vote();
        vote.setCandidate("Cuarzo");
        vote.setCandidate("Feldespato");
        vote.setCandidate("Mico");
    }

    function testVote_vote() public {
        vote.vote(1);
        //uint256 votesNumber = vote.candidates[1].votes();
        assertEq(vote.getVotes(1), 1);
        //bool votex = vote.voters[msg.sender]();
        //assertEq(votex, true);
        vm.expectRevert("You have already voted");
        vote.vote(0);
    }

    function testVote_closingVote() public {
        vote.closeVoting();
        assertEq(vote.votingOpen(), false);
        vm.expectRevert("The voted is closed");
        vote.vote(2);
    }
}
