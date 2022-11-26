// SPDX-License-Identifier: MIT
pragma solidity 0.8.7;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract WETH is ERC20 {

    constructor() ERC20("Wrapped Ether", "WETH"){}

    function ETHtoWETH() public payable returns(address, uint256) {
        _mint(msg.sender, msg.value);
        return (msg.sender, msg.value);
    }

    function WETHtoETH(uint256 _amount) public returns(address, uint256) {
        _burn(msg.sender, _amount);
        return (msg.sender, _amount);
    }

    receive() external payable {
        ETHtoWETH();
    }
    fallback() external payable {
        ETHtoWETH();
    }

}