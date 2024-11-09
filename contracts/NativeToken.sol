// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {IERC20Metadata} from "@openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol";
import {Context} from "@openzeppelin/contracts/utils/Context.sol";
import {IERC20Errors} from "@openzeppelin/contracts/interfaces/draft-IERC6093.sol";

contract NativeToken is Context, IERC20, IERC20Metadata, IERC20Errors {
    string private _name;
    string private _symbol;
    uint8 private _decimals;
    address public immutable minter;

    // For testing purposes until VM state is available
    mapping(address account => uint256) private _balances;
    uint256 private _totalSupply;

    constructor(string memory name_, string memory symbol_, uint8 decimals_, address minter_) {
        _name = name_;
        _symbol = symbol_;
        _decimals = decimals_;
        minter = minter_;
    }

    function name() public view virtual override returns (string memory) {
        return _name;
    }

    function symbol() public view virtual override returns (string memory) {
        return _symbol;
    }

    function decimals() public view virtual override returns (uint8) {
        return _decimals;
    }

    function totalSupply() public view returns (uint256 supply) {
        assembly {
            // Get the token ID (current contract address)
            let token_id := address()

            // Store token ID at memory slot 0
            mstore(0x00, token_id)

            // Get the free memory pointer for result
            let result := mload(0x40)
            // Update free memory pointer
            mstore(0x40, add(result, 32))

            // Call TOTALSUPPLY opcode (0xb0)
            let success := staticcall(gas(), 0xb0, 0x00, 0x20, result, 32)
            if iszero(success) {
                revert(0, 0)
            }

            // Load result into return value
            supply := mload(result)
        }
    }

    function balanceOf(address account) public view returns (uint256 tokenBalance) {
        if (account == address(0)) {
            revert("ERC20: address zero is not a valid owner");
        }

        assembly {
            // Get the token ID (current contract address)
            let token_id := address()

            // Store token_id and account in memory
            // Layout: [token_id (32 bytes)][account (32 bytes)]
            mstore(0x00, token_id)
            mstore(0x20, account)

            // Get the free memory pointer for result
            let result := mload(0x40)
            // Update free memory pointer
            mstore(0x40, add(result, 32))

            // Call BALANCEOF opcode (0xb2)
            let success := staticcall(gas(), 0xb2, 0x00, 0x40, result, 32)
            if iszero(success) {
                revert(0, 0)
            }

            // Load result into return value
            tokenBalance := mload(result)
        }
    }

    function transfer(address to, uint256 value) public virtual override returns (bool) {
        address owner = _msgSender();
        _transfer(owner, to, value);
        return true;
    }

    function allowance(address, address) public view virtual override returns (uint256) {
        return 0;
    }

    function approve(address spender, uint256 value) public virtual override returns (bool) {
        emit Approval(msg.sender, spender, value);
        return true;
    }

    function transferFrom(
        address from,
        address to,
        uint256 value
    ) public virtual override returns (bool) {
        if (from == address(0)) {
            revert ERC20InvalidSender(address(0));
        }
        if (to == address(0)) {
            revert ERC20InvalidReceiver(address(0));
        }
        _transfer(from, to, value);
        return true;
    }

    function _transfer(address from, address to, uint256 value) internal virtual {
        if (from == address(0)) {
            revert ERC20InvalidSender(address(0));
        }
        if (to == address(0)) {
            revert ERC20InvalidReceiver(address(0));
        }

        uint256 fromBalance = _balances[from];
        if (fromBalance < value) {
            revert ERC20InsufficientBalance(from, fromBalance, value);
        }

        unchecked {
            _balances[from] = fromBalance - value;
            _balances[to] += value;
        }

        emit Transfer(from, to, value);
    }

    function _mint(address to, uint256 value) internal virtual {
        if (to == address(0)) {
            revert ERC20InvalidReceiver(address(0));
        }

        _totalSupply += value;
        _balances[to] += value;

        emit Transfer(address(0), to, value);
    }
}
