// SPDX-License-Identifier: MIT
pragma solidity 0.8.7;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/security/Pausable.sol";

contract ETH is ERC20 {
    constructor() ERC20("Ethereum", "ETH") {}

    function buyNavich(uint256 tokenAmount) public {
        _mint(msg.sender, tokenAmount);
    }
}

contract ETH2 is ERC20, Pausable {

    ERC20 immutable eth;
    address public immutable contractOwner;
    uint256 public constant MAX_SUPPLY = 55;
    uint256 public constant ETH_2_PRICE = 2;

    constructor(address _eth) ERC20("Ethereum 2.0", "ETH2") {
        eth = ERC20(_eth);
        contractOwner = msg.sender;
    }

    function buyNavich2(uint256 ethFee, uint256 eth2Amount) public whenNotPaused {

        uint256 publicFee  = eth2Amount * ETH_2_PRICE;
        uint256 privateSaleFee = publicFee/2; 
        uint256 saleStart = block.timestamp + 3600;           // Sale Starts in 1 hour
        uint256 saleEnd = saleStart + 18000;

        require(balanceOf(msg.sender) == 0, "Tokens already minted at this address");
        require(totalSupply() + eth2Amount <= MAX_SUPPLY, "Sold out =D");

        if(block.timestamp >= saleStart && block.timestamp <= saleEnd){
            require(ethFee == privateSaleFee, "Not Enough Fee on-Sale");
        } else {
            require(ethFee == publicFee, "Not Enough Fee");
        }

        eth.transferFrom(msg.sender, contractOwner, ethFee);
        _mint(msg.sender, eth2Amount);
    }

    function pauseContract() external {
        _pause();
    }
    function unPauseContract() external {
        _unpause();
    }
    
}