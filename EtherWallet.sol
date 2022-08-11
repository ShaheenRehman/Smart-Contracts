// SPDX-License-Identifier: MIT
pragma solidity 0.8.5;

contract EtherWallet {
    address public owner = msg.sender;

    function recieve() public payable {}

    function send(address payable _guy, uint amount) public payable onlyOwner {
        (bool success, ) = _guy.call{value: amount}("");
        require(success, "Failed");
    }

    function balance() public view returns (uint) {
        return address(this).balance;
    }

    modifier onlyOwner() {
        require(owner == msg.sender, "Chor! Chor! Chor!");
        _;
    }
}
