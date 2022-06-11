#!/usr/bin/env bats

setup() {
  export SMARKY_INDEX="${BATS_TMPDIR}/smarky-index"
  rm -f "$SMARKY_INDEX"

  rootDir="$(cd "$(dirname "$BATS_TEST_FILENAME")" && pwd)"
  PATH="$rootDir:$PATH"
}

@test "can run our script" {
  smarky
}
