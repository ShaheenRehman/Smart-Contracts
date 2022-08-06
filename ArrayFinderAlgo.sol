////SPDX-License-Identifier: MIT
pragma solidity 0.8.7;

library LibFinderAlgorigthm {
    function find(uint[] storage arr, uint x) internal view returns (bool) {
        for (uint i = 0; i < arr.length; i++) {
            if (arr[i] == x) {
                return true;
            }
        }
        return false;
    }
}

contract ArrayFinderAlgo {
    using LibFinderAlgorigthm for uint[];

    uint[] public arr = [1, 2, 3, 4, 5];

    function finder(uint x) public view returns (bool) {
        return arr.find(x);
    }
}
