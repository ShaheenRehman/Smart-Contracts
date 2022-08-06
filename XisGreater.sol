////SPDX-License-Identifier: MIT
pragma solidity 0.8.7;

library IsXgreater {
    function maths(uint x, uint y) internal pure returns (uint) {
        return x >= y ? x : y;
    }
}

contract XisGreater {
    function mathsXandY(uint x, uint y) public pure returns (uint) {
        return MathsIsXgreater.mathsLogic(x, y);
    }
}
