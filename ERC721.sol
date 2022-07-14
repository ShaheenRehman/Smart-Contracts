// SPDX-License-Identifier: MIT
pragma solidity ^0.8.5;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract ERC721NFT is ERC721 {
    constructor(
        string memory _name,
        string memory _symbol,
        uint tokenId
    ) ERC721(_name, _symbol) {
        _mint(msg.sender, tokenId);
    }
}
