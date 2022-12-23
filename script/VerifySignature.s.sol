// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "forge-std/Script.sol";
import "../test/DarkOracle.t.sol";

contract VerifySignatureScript is Script, Test {
    uint8 v = 27;
    bytes32 r =
        0xe3098f266ada8315f1ffdd3a98d744cb8f027af63738678a40432504a6e0b08d;
    bytes32 s =
        0x1420fcd6294f171add38326c0dd7a7328accad1043b7d24cd5520a4a11894b75;

    function run() public {
        DarkOracleMock mock =
            DarkOracleMock(0x5FbDB2315678afecb367f032d93F642f64180aa3);

        vm.startBroadcast();
        bool valid = mock.verifyPacket(420, 16717551430, v, r, s);
        vm.stopBroadcast();

        console.log(valid);
    }
}
