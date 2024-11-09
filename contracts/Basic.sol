// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.20;

import "./NativeToken.sol";

contract Basic is NativeToken {
    constructor(
        uint256 _initialSupply
    ) NativeToken("Just a basic on-chain asset", "BASIC", 18, msg.sender) {
        _mint(msg.sender, _initialSupply);
    }

    function mint(uint256 _amount) public {
        _mint(msg.sender, _amount);
    }
}
