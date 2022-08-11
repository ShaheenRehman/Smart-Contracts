// SPDX-License-Identifier: MIT
pragma solidity 0.8.5;

contract SumArray {
    function sumarray(uint[] memory array) public pure returns (uint) {
        uint sum = 0;
        for (uint i = 0; i < array.length; i++) {
            sum += array[i];
        }
        return sum;
    }
}
