// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/DarkOracle.sol";

contract DarkOracleMock is DarkOracle {
    function setTrusted(address who, bool isTrusted) external {
        trusted[who] = isTrusted;
    }

    function getDigest(uint256 value, uint256 deadline)
        external
        view
        returns (bytes32)
    {
        return computeDigest(
            keccak256(
                abi.encodePacked(
                    keccak256("Verify(uint256 value,uint256 deadline)"),
                    value,
                    deadline
                )
            )
        );
    }
}

contract DarkOracleTest is Test {
    DarkOracleMock oracle;

    function setUp() public {
        oracle = new DarkOracleMock();
    }

    function testCorrectness() public {
        (address bot, uint256 botPk) = makeAddrAndKey("BOT");

        (uint8 v, bytes32 r, bytes32 s) =
            vm.sign(botPk, oracle.getDigest(420, block.timestamp));

        bool validPacket = oracle.verifyPacket(420, block.timestamp, v, r, s);

        assertEq(validPacket, false);

        oracle.setTrusted(bot, true);

        validPacket = oracle.verifyPacket(420, block.timestamp, v, r, s);

        assertEq(validPacket, true);
    }
}
