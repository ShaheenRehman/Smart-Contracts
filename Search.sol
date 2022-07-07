// SPDX-License-Identifier: MIT
pragma solidity >=0.5.0 <0.9.0;

contract Search {
    function search(
        uint[] memory array,
        uint len,
        uint n
    ) public pure returns (string memory) {
        for (uint i = 0; i < len; i++) {
            if (array[i] == n) {
                return "Main Ismey hii hun :)";
            }
        }
        return "Main Ismay nahi hun xD";
    }
}
