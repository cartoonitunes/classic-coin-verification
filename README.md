# Classic Coin — Bytecode Verification

Proof of source code for Classic Coin:

- [`0x7B484f9272C9b17e28A5D87d63820F31Be92B6E7`](https://ethereumhistory.com/contracts/0x7B484f9272C9b17e28A5D87d63820F31Be92B6E7) — deployed Jan 10 2016 (block 826,605)

## Contract

An early Ethereum subcurrency featuring a `token()` faucet function — users call it to claim tokens. Based on the classic ethereum.org coin tutorial but with a simplified single-mapping design and a faucet mechanic (defaults to 10,000 tokens if amount is 0).

## Compiler

| Field | Value |
|---|---|
| **Image** | `solc-jan20` (native C++, commit 67c855c5, Jan 20 2016 build) |
| **Flag** | `--optimize --bin-runtime` |
| **Runtime size** | 276 bytes |

## Verification

Requires Docker with the `solc-jan20` image (built from [webthree-umbrella](https://github.com/ethereum/webthree-umbrella) v0.2.0, commit 67c855c5):

```bash
./verify.sh
```

Expected: `✅ EXACT MATCH — Classic Coin bytecode verified (276 bytes)`

## Key Insights

1. **`--optimize` required** — produces EXP-based selector dispatch; unoptimized gives 1408b vs 276b target
2. **`token(uint amount)` is a faucet** — NOT a getter; sets `coinBalanceOf[msg.sender] = amount`, defaulting to 10,000 if 0
3. **Public mapping auto-getter** — `mapping(address=>uint) public coinBalanceOf` generates the `coinBalanceOf(address)` selector automatically
4. **No events are indexed** — `CoinTransfer` uses LOG1 (single topic = signature only)
5. **No explicit constructor** — the constructor is implicit (empty)

## Selectors

- `044215c6` → `token(uint256)` — claim/initialize tokens
- `90b98a11` → `sendCoin(address,uint256)` — transfer
- `bbd39ac0` → `coinBalanceOf(address)` — balance getter

## Files

- `Coin.sol` — Solidity source
- `runtime.hex` — Expected runtime bytecode (276 bytes)
- `verify.sh` — Verification script (requires Docker)
