#!/usr/bin/env bats

setup() {
  load 'helper/bats-support/load'
  load 'helper/bats-assert/load'

  export SMARKY_INDEX="${BATS_TMPDIR}/smarky-index.db"
  rm -f "$SMARKY_INDEX"

  rootDir="$(cd "$(dirname "$BATS_TEST_FILENAME")" && pwd)/.."
  PATH="$rootDir:$PATH"
}

@test "outputs usage information when run without args" {
  run smarky
  assert_output --partial "Usage information:"
}

@test "outputs usage information when run with unknown command" {
  run smarky command-that-will-never-exist
  assert_output --partial "Usage information:"
}

@test "index file is created when running the script" {
  run smarky
  assert [ -e "$SMARKY_INDEX" ]
}
