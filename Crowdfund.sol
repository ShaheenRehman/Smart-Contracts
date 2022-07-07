// SPDX-License-Identifier: MIT
pragma solidity ^0.8.5;


contract Crowdfund {

    error NotOwner();

    address[] public funders;

    mapping(address => uint) public amountFunded;
    
    uint private constant MINIMUM_USD = 50000; //Wei

    address public immutable ContractOwner;

    constructor() {
        ContractOwner = msg.sender;
    }

    function Fund() payable public {
        require(msg.value >= MINIMUM_USD, "Unsuficient Amount");
        funders.push(msg.sender);
        amountFunded[msg.sender] = msg.value;
    }

    function Balance() public view returns(uint) {
        return address(this).balance;
    }

    function Withdraw() public contractOwnerOnly {
        for (uint i; i < funders.length; i++) {
            address funder = funders[i];
            amountFunded[funder] = 0;
        }
        funders = new address[](0);

        (bool success,) =  payable(msg.sender).call{value: address(this).balance}("");
        require(success, "Transaction Failed");
    }

    modifier contractOwnerOnly() {
        // require(msg.sender == ContractOwner, "Chor! Chor! Chor!");
        if(msg.sender != ContractOwner) { revert NotOwner(); }
        _;
    }

    receive() external payable {
       Fund();
    }
    fallback() external payable {
       Fund();
    }

}