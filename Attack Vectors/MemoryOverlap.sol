//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

contract Vulnerable {
    function addressNamespace(address account1, address account2) public returns(bytes32 namespace) {
        assembly {
            mstore(0x00, account1)
            mstore(0x14, account2) /*bug: this will overwrite the last 12 bytes of account1 
            as memory offsets start from 32 byte and are from right to left*/
            namespace := keccak256(0x00, 0x28)
        }
    }
}

contract NonVulnerable {
    function addressNamespace(address account1, address account2) public returns(bytes32 namespace) {
        assembly {
            mstore(0x00, shl(96, account1)) //we shift left with 96 bits to remove the 12 bytes of 0s
            mstore(0x14, shl(96, account2)) /* this will now overwrite 0s as we have moved the address bytes 
            making it so the address bytes are exactly next to eachother*/
            namespace := keccak256(0x00, 0x28) //we hash only the address bytes so theres no 0s to make wrong hashing
        }
    }
}