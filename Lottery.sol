// SPDX-License-Identifier: MIT
pragma solidity ^0.8.5;

contract Lottery {
    address public immutable owner;
    address payable[] public players;
    uint private immutable entryFee = 5 ether;
    address public winner;

    constructor() {
        owner = msg.sender;
    }

    function enterLottery() public payable {
        require(msg.value >= entryFee, "Pehli Fursat Main Nikal. Gareeb!");
        players.push(payable(msg.sender));
    }

    function getRandomNumber() public view returns (uint) {
        return uint(keccak256(abi.encodePacked(owner, block.timestamp)));
    }

    function pickWinner() public OnlyOwner {
        uint index = getRandomNumber() % players.length;
        winner = players[index];
        (bool success, ) = winner.call{value: address(this).balance}("");
        require(success, "Transfer Failed");

        players = new address payable[](0);
    }

    modifier OnlyOwner() {
        require(msg.sender == owner, "Chor! Chor! Chor!");
        _;
    }

    function getBalance() public view returns (uint) {
        return address(this).balance;
    }
}
