// SPDX-License-Identifier: MIT
pragma solidity 0.8.0;

contract Calculator {
    int x;
    int y;

    function input_XY(int a, int b) public {
        x = a;
        y = b;
    }

    function add() public view returns (int) {
        return x + y;
    }

    function sub() public view returns (int) {
        return x - y;
    }

    function multiply() public view returns (int) {
        return x * y;
    }

    function divide() public view returns (int) {
        return x / y;
    }

    function modulus() public view returns (int) {
        return x % y;
    }
}
