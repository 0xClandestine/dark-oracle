// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "solbase/utils/EIP712.sol";

abstract contract DarkOracle is EIP712("DarkOracle", "1") {
    /// -----------------------------------------------------------------------
    /// Events
    /// -----------------------------------------------------------------------

    event TrustStatusChanged(address account, bool trusted);

    /// -----------------------------------------------------------------------
    /// Mutables
    /// -----------------------------------------------------------------------

    mapping(address => bool) public trusted;

    /// -----------------------------------------------------------------------
    /// Logic
    /// -----------------------------------------------------------------------

    error DeadlineElapsed();
    error InvalidSignature();

    function verifyPacket(
        uint256 value,
        uint256 deadline,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) public view virtual returns (bool) {
        // assert deadline has not elapsed
        if (block.timestamp > deadline) return false;

        if (
            !trusted[ecrecover(
                computeDigest(
                    keccak256(
                        abi.encodePacked(
                            keccak256("Verify(uint256 value,uint256 deadline)"),
                            value,
                            deadline
                        )
                    )
                ),
                v,
                r,
                s
            )]
        ) return false;

        return true;
    }
}
