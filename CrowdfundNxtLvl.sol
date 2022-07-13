// SPDX-License-Identifier: MIT
pragma solidity ^0.8.5;

import "hardhat/console.sol";
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

//Library should be in a seperate file (PriceConverter.sol) for better working.
library PriceConverter {
    function getPrice() internal view returns (uint256) {
        AggregatorV3Interface priceFeed = AggregatorV3Interface(
            0x8A753747A1Fa494EC906cE90E9f37563A8AF630e
        );
        (, int256 answer, , , ) = priceFeed.latestRoundData();
        return uint256(answer * 10000000000);
    }

    function getConversionRate(uint256 ethAmount)
        internal
        view
        returns (uint256)
    {
        uint256 ethPrice = getPrice();
        uint256 ethAmountInUsd = (ethPrice * ethAmount) / 1000000000000000000;
        return ethAmountInUsd;
    }
}

error Crowdfund__NotOwner();

contract Crowdfund {
    using PriceConverter for uint;

    address[] public funders;

    mapping(address => uint) public amountFunded;

    uint public constant MINIMUM_USD = 50 * 10**18;

    address public immutable ContractOwner;

    AggregatorV3Interface public priceFeed;

    constructor(address priceFeedAddress) {
        ContractOwner = msg.sender;
        priceFeed = AggregatorV3Interface(priceFeedAddress);
    }

    function Fund() public payable {
        require(
            msg.value.getConversionRate() >= MINIMUM_USD, /*priceFeed*/ //commented-out priceFeed because with lib in the same file, this was giving err but when lib was in another file, this was working well.
            "Pehli Fursat Main Nikal! Gareeb xD"
        );
        // console.log("AOA");
        funders.push(msg.sender);
        amountFunded[msg.sender] = msg.value;
    }

    // function Balance() public view returns (uint) {
    //     return address(this).balance;
    // }

    function Withdraw() public contractOwnerOnly {
        for (uint i; i < funders.length; i++) {
            address funder = funders[i];
            amountFunded[funder] = 0;
        }
        funders = new address[](0);

        (bool success, ) = payable(msg.sender).call{
            value: address(this).balance
        }("");
        require(success, "Transaction Failed");
    }

    modifier contractOwnerOnly() {
        // require(msg.sender == ContractOwner, "Chor! Chor! Chor!");
        if (msg.sender != ContractOwner) {
            revert Crowdfund__NotOwner();
        }
        _;
    }

    receive() external payable {
        Fund();
    }

    fallback() external payable {
        Fund();
    }
}
