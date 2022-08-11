// SPDX-License-Identifier: MIT
pragma solidity 0.8.0;

contract Counter {
    int public counter;

    function countAdd() public returns (int) {
        return ++counter;
    }

    function countSub() public returns (int) {
        return counter--;
    }
}
