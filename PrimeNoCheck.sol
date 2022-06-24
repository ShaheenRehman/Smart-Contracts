// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Day3 {
    function prime(uint n) public pure returns (string memory) {
        for (uint i = 2; i < n; i++) {
            if (n % i == 0) {
                return "Not a Prime Number";
            }
        }
        return "Prime Number";
    }
}
