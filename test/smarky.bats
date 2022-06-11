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

  run smarky select 1
  assert_output "cat"
}

@test "commands have special symbols preserved" {
  specialCommand="I'm a special!! cőmmand テスト \" \"\" blah ()% %% %%% \$\$\$"
  run smarky create "$specialCommand"

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

  run smarky create "$commandOne" "$commandOneDesc"
  run smarky create "$commandTwo" "$commandTwoDesc"

  run smarky list
  assert_output --partial "$commandOneDesc"
  assert_output --partial "$commandTwoDesc"
}
