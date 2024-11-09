// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title NativeTokenReceiver
 * @dev Minimal example showing how to handle Native Token receipts
 */
contract NativeTokenReceiver {
    event TokensReceived(address indexed token, uint256 amount);
    event TokensForwarded(address indexed token, address indexed to, uint256 amount);

    /**
     * @dev Example of how to process received native tokens using CALLVALUES
     */
    function onTokensReceived() external {
        assembly {
            // CALLVALUES opcode (0xb3) returns [length, (token_id, amount)...]
            let length := 0 // Will be actual count from CALLVALUES

            // Process received tokens
            switch length
            case 0 {
                // No tokens received
            }
            default {
                // At least one token received
                let token_id := 0 // Will be from CALLVALUES
                let amount := 0 // Will be from CALLVALUES

                // Emit event for first token (example)
                mstore(0x00, amount)
                log3(
                    0x00,
                    0x20,
                    // keccak256("TokensReceived(address,uint256)")
                    0x48864681b64d418a40ce2f1a2c4880e962d732082427c54b649bee1cc69ae3e2,
                    token_id,
                    amount
                )
            }
        }
    }

    /**
     * @dev Example of how to forward received tokens using NTCALL
     */
    function forwardTokens(address to) external {
        assembly {
            // CALLVALUES to get received tokens
            let length := 0 // Will be from CALLVALUES

            // NTCALL to forward tokens
            let success := 1 // Will be actual NTCALL result

            if iszero(success) {
                revert(0, 0)
            }

            // Emit event
            mstore(0x00, 0) // amount placeholder
            log3(
                0x00,
                0x20,
                // keccak256("TokensForwarded(address,address,uint256)")
                0x7ff126db8024424bbac25c9b365da342955f6e5c6847f7e2f4760d69fc4c7d50,
                caller(),
                to
            )
        }
    }
}
