#!/usr/bin/env bash

binary="$1"
shift

rm -rf afl-sync
mkdir -p afl-sync

function cleanup {
  echo "Cleaning up fuzzers"
  kill -9 "$fuzzer01" || true
  kill -9 "$fuzzer02" || true
  kill -9 "$fuzzer03" || true
  kill -9 "$fuzzer04" || true
}
trap cleanup EXIT

./sources/AFL/afl-fuzz -i inputs/afl -o afl-sync -M fuzzer01 "$binary" "$@" > /dev/null &
fuzzer01="$!"
sleep 5

./sources/AFL/afl-fuzz -i inputs/afl -o afl-sync -S fuzzer02 "$binary" "$@" > /dev/null  &
fuzzer02="$!"

./sources/AFL/afl-fuzz -i inputs/afl -o afl-sync -S fuzzer03 "$binary" "$@" > /dev/null &
fuzzer03="$!"

./sources/AFL/afl-fuzz -i inputs/afl -o afl-sync -S fuzzer04 "$binary" "$@" > /dev/null &
fuzzer04="$!"

watch ./sources/AFL/afl-whatsup afl-sync
