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
  run smarky create "a simple cat" "cat"

  r="$(sqlite3 "$SMARKY_INDEX" "select * from commands where command = 'cat';")"
  assert [ -n "$r" ]

  run smarky select 1
  assert_output "cat"
}

@test "commands have special symbols preserved" {
  specialCommand="I'm a special!! cőmmand テスト \" \"\" blah ()% %% %%% \$\$\$"
  run smarky create "$specialCommand" "$specialCommand"

  raw="$(sqlite3 "$SMARKY_INDEX" "select command from commands where id = 1;")"
  assert [ "$raw" = "$specialCommand" ]

  run smarky select 1
  assert_output "$specialCommand"
}

@test "usage information is shown if select gets no args" {
  run smarky select
  assert_output --partial "Usage information:"
}

@test "no output is given when id isn't found" {
  run smarky select 123
  refute_output
}

@test "created bookmarks show in the bookmarks list" {
  commandOne="tar xvzf" commandOneDesc="extract tarball verbosely"
  commandTwo="rsync -a" commandTwoDesc="archive sync with rsync"

  run smarky create "$commandOneDesc" "$commandOne"
  run smarky create "$commandTwoDesc" "$commandTwo"

  run smarky list
  assert_output --partial "$commandOneDesc"
  assert_output --partial "$commandTwoDesc"
}

@test "removed command disappears from list" {
  commandOne="tar xvzf" commandOneDesc="extract tarball verbosely"
  commandTwo="rsync -a" commandTwoDesc="archive sync with rsync"

  run smarky create "$commandOneDesc" "$commandOne"
  run smarky create "$commandTwoDesc" "$commandTwo"
  run smarky remove 1

  run smarky list
  refute_output --partial "$commandOneDesc"
  assert_output --partial "$commandTwoDesc"
}

@test "removing nonexistent command gives no error or error message" {
  run smarky remove 1234432
  refute_output
}

@test "commands can be updated after first created" {
  run smarky create "a simple cat" "cat"
  run smarky select 1
  assert_output "cat"

  run smarky update 1 "a simple bat" "bat"
  run smarky select 1

  refute_output --partial "cat"
  assert_output --partial "bat"
}

@test "updating a command that doesn't exist does nothing" {
  run smarky create "example" "example"
  listOutput="$(smarky list)"

  run smarky update 1234 "example" "example"
  refute_output

  run smarky list
  assert_output "$listOutput"
}

@test "update command doesn't change description if no args are given" {
  run smarky create "example" "command"
  EDITOR="echo" run smarky update 1
  run smarky list
  assert_output --partial "example"
}

@test "update command outputs usage information when given no args" {
  run smarky update
  assert_output --partial "Usage information:"
}
