#!/usr/bin/env bats

setup() {
  load 'helper/bats-support/load'
  load 'helper/bats-assert/load'

  export SMARKY_INDEX="${BATS_TMPDIR}/smarky-index"
  rm -f "$SMARKY_INDEX"

  rootDir="$(cd "$(dirname "$BATS_TEST_FILENAME")" && pwd)/.."
  PATH="$rootDir:$PATH"
}

@test "can run our script" {
  smarky
}
