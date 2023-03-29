// SPDX-License-Identifier: GPL-3.0
pragma solidity >= 0.8.0;

contract Counter {
    uint value;

    function intialize(uint x) public {
        value = x;
    }

    function get() view public returns (uint){
        return value;
    }

    function increment(uint n) public {
        value = value + n;
    }

    function decremet(uint n) public {
        value = value -n;
    }
}