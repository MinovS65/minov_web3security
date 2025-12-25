//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

library VerifySig {
    function verify(address _signer, string memory _message, bytes memory _sig) external pure returns(bool) {
        bytes32 messageHash = getMessageHash(_message);
        bytes32 ethSignedMessageHash = getEthSignedMessageHash(messageHash);
        return recover(ethSignedMessageHash, _sig)==_signer;
    }

    function getMessageHash(string memory _message) public pure returns(bytes32) {
        return keccak256(abi.encodePacked(_message));
    }
 
    function getEthSignedMessageHash(bytes32 _messageHash) public pure returns(bytes32) {
        return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", _messageHash));
    }

    function recover(bytes32 _ethSignedMessageHash, bytes memory _sig) public pure returns(address) {
        (bytes32 r, bytes32 s, uint8 v) = _split(_sig);
        return ecrecover(_ethSignedMessageHash, v, r, s);
    }

    function _split(bytes memory _sig) private pure returns(bytes32 r, bytes32 s, uint8 v) {
        require(_sig.length == 65, "invalid signature length");
        assembly {
            r:=mload(add(_sig, 32))
            s:=mload(add(_sig, 64))
            v:=byte(0, mload(add(_sig, 96)))
        }
    }
}

contract VulnerableMultiSig {
    using VerifySig for bytes32;

    address[2] public owners;

    constructor(address[2] memory _owners) payable {
        owners = _owners;
    }

    function deposit() public payable { require(msg.value>0)}

    function transfer(address to, uint amount. bytes[2] memory sigs) public payable{
        bytes32 txHash = getTxHash(to, amount);

    }   

    function getTxHash(address _to, uint256 _amount) public view returns (bytes32) {
        return keccak256(abi.encodePacked(_to, _amount));
    }

    function checkSigs(bytes[2] memory sigs. bytes32 txHash) public view returns(bool) {
        bytes32 ethSignedHash = txHash.getEthSignedMessageHash();
        for (int i;i<sigs.length;i++){
            address signer = ethSignedHash.recover(sigs[i]);
            if (signer != owners[i]) {
                return false;
            }
        }
        return true;
    }
}