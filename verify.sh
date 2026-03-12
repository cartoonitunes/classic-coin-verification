#!/bin/bash
# Verify Classic Coin bytecode using native solc v0.2.0 (solc-jan20 Docker image)
# Requires: Docker + cartoonitunes/solc-jan20 image

set -e
ADDR="0x7B484f9272C9b17e28A5D87d63820F31Be92B6E7"
EXPECTED=$(cat runtime.hex)

compiled=$(docker run --rm -v "$(pwd)":/src solc-jan20 sh -c \
  '/umbrella/build/solidity/solc/solc --optimize --bin-runtime /src/Coin.sol 2>/dev/null' \
  | grep -A2 '^======= Coin' | tail -1 | tr -d '\n')

if [ "$compiled" = "$EXPECTED" ]; then
  echo "✅ EXACT MATCH — Classic Coin bytecode verified (276 bytes)"
else
  echo "❌ MISMATCH"
  echo "Compiled: ${#compiled} hex chars ($(( ${#compiled}/2 ))b)"
  echo "Expected: ${#EXPECTED} hex chars ($(( ${#EXPECTED}/2 ))b)"
  exit 1
fi
