// SPDX-License-Identifier: aIT
pragma solidity ^0.8.5;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20.sol";

contract ERC20Token is ERC20 {
    constructor(
        string memory _name,
        string memory _symbol,
        uint initialSupply
    ) ERC20(_name, _symbol) {
        _mint(msg.sender, initialSupply * (10**18));
    }
}
