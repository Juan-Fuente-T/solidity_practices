/*
Votación Simple: Diseña un contrato de votación simple en el que los usuarios pueden
emitir votos por candidatos y consultar los resultados. El contrato tendrá:
a. Un struct Candidate con un string para el nombre del candidato, y un uint256 para el
conteo de sus votos
b. Un mapping que controlará si una address ya ha votado
c. Un array dinámico de candidatos (Candidates)
d. Un booleano votingOpen que indicará si la votación está activa
e. Una función vote() que permitirá votar a un candidato. Recibirá el índice del array del
candidato a votar. Deberá incrementar la cantidad de votos del candidato, y marcar al
votante para indicar que ya ha votado
f. Una función closeVoting() que permitirá al owner del contrato cerrar la votación
(votingOpen = false)
*/
// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.21;

contract Vote {
    struct Candidate {
        string name;
        uint256 votes;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }

    mapping(address => bool) public voters;
    Candidate[] public candidates;

    bool public votingOpen;
    address owner;

    constructor() {
        owner = msg.sender;
        votingOpen = true;
    }

    function setCandidate(string memory _name) external {
        require(votingOpen == true, "Voting is not open");
        candidates.push(Candidate(_name, 0));
    }

    function vote(uint8 _candidate) external {
        require(votingOpen, "The voted is closed");
        require(!voters[msg.sender], "You have already voted");
        candidates[_candidate].votes += 1;
        voters[msg.sender] = true;
    }

    function closeVoting() external onlyOwner {
        votingOpen = false;
    }

    function getVotes(uint8 _candidate) external view returns (uint256) {
        require(_candidate < candidates.length, "Ese candidato no existe");
        return candidates[_candidate].votes;
    }
}
