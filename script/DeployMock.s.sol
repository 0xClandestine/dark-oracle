// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "../test/DarkOracle.t.sol";

contract DeployMockScript is Script {
    function run() public {
        vm.startBroadcast();
        new DarkOracleMock().setTrusted(0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266, true);
        vm.stopBroadcast();
    }
}
