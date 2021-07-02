// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract PiggyBank {
    using SafeERC20 for IERC20;
    using SafeMath for uint256;

    address public token;

    mapping(address => uint256) public assets;

    constructor(address _token) {
        token = _token;
    }

    function deposit(uint256 amount) public {
        IERC20(token).safeTransferFrom(msg.sender, address(this), amount);
        assets[msg.sender] = assets[msg.sender].add(amount);
    }

    function withdraw(uint256 amount) public {
        require(assets[msg.sender] >= amount, "invalid amount");
        IERC20(token).safeTransfer(msg.sender, amount);
        assets[msg.sender] = assets[msg.sender].sub(amount);
    }
}
