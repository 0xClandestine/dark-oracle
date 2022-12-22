// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "forge-std/Script.sol";
import "../test/DarkOracle.t.sol";

contract VerifySignatureScript is Script, Test {
    uint8 v = 27;
    bytes32 r = 0xd7679e42380474bdb723606c76727baa5adcc497ccdc36dc1cbb66fe4b3d3691;
    bytes32 s = 0x71789c98ba79c67528d1bc115bbae3263f4ce140b6f92d80f0f3f66fdf976eb3;

    function run() public {
        vm.startBroadcast();

        bool valid = DarkOracleMock(0x5FbDB2315678afecb367f032d93F642f64180aa3)
            .verifyPacket(12345, 1500000000, v, r, s);

        assertTrue(valid);

        vm.stopBroadcast();
    }
}
