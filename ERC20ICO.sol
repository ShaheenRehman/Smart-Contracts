// SPDX-License-Identifier: MIT
pragma solidity 0.8.7;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";

contract ERC20ICO is ERC20, Ownable  {

    uint256 public constant maxSupply = 55 * 10**18;
    uint256 public constant TOKEN_PRICE = 2 ether;
    uint256 private tokenPriceOnSale;

    constructor() ERC20("Navich", "NAVICH") {}

    function setTokenPriceOnSale(uint256 _tokenPriceOnSale) public onlyOwner {
        tokenPriceOnSale = _tokenPriceOnSale * 10**18;
    }

    function buyToken(uint256 tokenAmount) public payable {

        uint256 publicFee  = tokenAmount * TOKEN_PRICE;
        uint256 privateSaleFee = tokenPriceOnSale * tokenAmount; 
        uint256 TokenAmountInDecimals = tokenAmount * 10**18;
        uint256 saleStart = block.timestamp + 3600;           // Sale Starts in 1 hour
        uint256 saleEnd = saleStart + 18000;                  //Sale Ends after 5 hours
        require( (totalSupply() + TokenAmountInDecimals) <= maxSupply, " Sold-out Alhumdulilah :) ");

        if(block.timestamp >= saleStart && block.timestamp <= saleEnd && tokenPriceOnSale != 0) {
            require(msg.value == privateSaleFee, "Puray Paisay Bhar");
        } else {
            require(msg.value == publicFee, "Puray Paisay Bhar");
        }
        _mint(msg.sender, TokenAmountInDecimals);

    }

    function withdraw() external onlyOwner {
        (bool success,) = payable(msg.sender).call{value: address(this).balance}("");
        require(success);
    }

    function getBalance() external view returns(uint256) {
        return address(this).balance;
    }

    function getTokenPriceOnSale() external view returns(uint256) {
        return tokenPriceOnSale;
    }
}