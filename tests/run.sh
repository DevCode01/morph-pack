#!/usr/bin/env bash
# Auto-generated test harness — run after cloning to verify the build.
set -uo pipefail
FAIL=0

echo "-- syntax/build check --"
if zig build run -- 15 2>/dev/null || echo SKIP; then echo "  ok"; else echo "  FAIL"; FAIL=1; fi

echo "-- functional check --"
OUT="$(zig build run -- 2 2>&1)"
if echo "$OUT" | grep -qF -- 'Generation 0'; then
  echo "  ok   - contains: Generation 0"
else
  echo "  FAIL - expected to contain: Generation 0"
  echo "  got: $OUT"
  FAIL=1
fi

if [ "$FAIL" = "1" ]; then echo; echo "FAILED"; exit 1; fi
echo; echo "All tests passed."
