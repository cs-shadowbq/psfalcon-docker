#!/usr/bin/env bash
set -e
for f in tests/test-*.sh; do
  bash "$f"
done