// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Delegate {
    address public owner;

    constructor(address _owner) {
        owner = _owner;
    }

    function pwn() public {
        owner = msg.sender;
    }
}

contract Delegation {
    address public owner;
    Delegate delegate;

    constructor(address _delegateAddress) {
        delegate = Delegate(_delegateAddress);
        owner = msg.sender;
    }

    fallback() external {
        (bool result,) = address(delegate).delegatecall(msg.data);
        if (result) {
            this;
        }
    }
}

// contract Force { /*
//                    MEOW ?
//          /\_/\   /
//     ____/ o o \
//     /~____  =ø= /
//     (______)__m_m)
//                    */ }
                   
// contract Hack {
    

//     receive()external payable  {}

//     function send(address payable  _force) public payable {
// selfdestruct(_force);
// }}