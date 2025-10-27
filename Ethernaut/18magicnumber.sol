// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

contract Hack {
    constructor(MagicNum target) {
        address solver;                  //got the bytecode from yt to return 42
        bytes memory bytecode = hex"69602a60005260206000f3600052600a6016f3";

        assembly {
            solver := create(0, add(bytecode, 0x20), 0x13)
        }

        target.setSolver(solver);
    }
}

contract MagicNum {
    address public solver;

    constructor() {}

    function setSolver(address _solver) public {
        solver = _solver;
    }

    /*
    ____________/\\\_______/\\\\\\\\\_____        
     __________/\\\\\_____/\\\///////\\\___       
      ________/\\\/\\\____\///______\//\\\__      
       ______/\\\/\/\\\______________/\\\/___     
        ____/\\\/__\/\\\___________/\\\//_____    
         __/\\\\\\\\\\\\\\\\_____/\\\//________   
          _\///////////\\\//____/\\\/___________  
           ___________\/\\\_____/\\\\\\\\\\\\\\\_ 
            ___________\///_____\///////////////__
    */
}
