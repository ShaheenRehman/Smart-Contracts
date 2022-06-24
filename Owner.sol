// SPDX-License-Identifier: MIT
pragma solidity ^0.8.5;

contract Owner {
    address public owner = msg.sender;

    function newOwner(address _newOwner) public onlyOnwer {
        require(_newOwner != address(0), "Request Failed");
        owner = _newOwner;
    }

    modifier onlyOnwer() {
        require(owner == msg.sender, "Chor! Chor! Chor!");
        _;
    }
}
