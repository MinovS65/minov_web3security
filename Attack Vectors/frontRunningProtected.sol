//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

 contract NoFrontrunning {
    bytes32 answerHash;
    mapping (address=>bytes32) public commits;
    mapping (address => uint256) public commitBlock;
    
    constructor(string memory answer) payable { answerHash = keccak256(abi.encodePacked(answer)); }

    function commit(bytes32 commitHash) public {
        commits[msg.sender]=commitHash;
        commitBlock[msg.sender]=block.number;
    }

    function submit(string memory answer, string memory salt) public payable{
        require(block.number>commitBlock[msg.sender], "Reveal too soon!");
        require(commits[msg.sender]==keccak256(abi.encodePacked(answer,salt,msg.sender)), "you have not commited that");
        require(answerHash==keccak256(abi.encodePacked(answer)), "incorrect answer");
        (bool sent,) = msg.sender.call{value: address(this).balance}("");
        require(sent, "call failed");
    }
}

contract GenerateHash {
    function gen(string memory answer, string memory salt) public view returns(bytes32) {
        return keccak256(abi.encodePacked(answer,salt,msg.sender));
    }
}
