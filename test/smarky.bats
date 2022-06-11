#!/usr/bin/env bats

setup() {
  load 'helper/bats-support/load'
  load 'helper/bats-assert/load'

  export SMARKY_INDEX="${BATS_TMPDIR}/smarky-index.db"

  rootDir="$(cd "$(dirname "$BATS_TEST_FILENAME")" && pwd)/.."
  PATH="$rootDir:$PATH"
}

teardown() {
  rm -f "$SMARKY_INDEX"
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

@test "commands table is updated when creating bookmarks" {
  run smarky create "cat"
  r="$(sqlite3 "$SMARKY_INDEX" "select * from commands where command = 'cat';")"
  assert [ -n "$r" ]
}

@test "commands have special symbols preserved" {
  specialCommand="I'm a special!! cőmmand テスト \" \"\" blah ()% %% %%% \$\$\$"
  run smarky create "$specialCommand"
  raw="$(sqlite3 "$SMARKY_INDEX" "select command from commands where id = 1;")"
  assert [ "$raw" = "$specialCommand" ]
}
