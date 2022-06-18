# smarky

A shell bookmarker similar to [marker](https://github.com/pindexis/marker), but
written purely in POSIX sh and using [fzf](https://github.com/junegunn/fzf) for
fuzzy matching.

SQLite is used for the index file. Something better probably exists.

Batteries (ZSH widget) included.

## Installation

Currently there is no packaged version of smarky, so you'll have to clone the
repository somewhere and ensure `smarky` is in your `$PATH`:

```sh
git clone https://github.com/d3adb5/smarky
PATH="$PATH:$(pwd)/smarky"
```

smarky depends on: `fzf`, `sqlite3`, `bat` (optional)

## Usage

You can get usage information by invoking `smarky` directly, but the main
script itself is a very simple CRUD:

![smarky is just a CRUD](https://user-images.githubusercontent.com/8827351/174419214-bc65c62a-a2ea-4fff-b826-d53503825573.gif)

This is by design. You can use it directly if you like, but you're encouraged
to just pipe it around. The project's focus is on possible applications of it,
two of which are the ZLE widgets present in this repository.

If you choose to use the widgets as they are in this repository, the binding to
retrieve commands from smarky is `Ctrl-J` by default. You can get the binding
and the widget in your shell configuration by adding the following to your
`.zshrc`:

```sh
source path/to/the/smarky/repo/zsh/widgets.zsh
```

This is what it looks like in action:

![smarky ZLE widget](https://user-images.githubusercontent.com/8827351/174420744-fd6ce2f1-1e98-4fed-80b0-69b5cfc9740d.gif)

### Templated Bookmarks

On top of just storing your commands, smarky comes with another ZLE widget that
allows you to jump to the next "template" field. Fields are simply parts of the
command wrapped in double curly braces, like such:

```sh
socat {{ protocol }}-listen:{{ port }},fork,reuseaddr {{ protocol }}:{{ remote ip addr }}:{{ port }}
```

You can store something like this, or text that is even more complicated, place
it in the command line from smarky by pressing Ctrl + J, then jump to the first
field with Ctrl + G, pressing the same combination for the next field, and the
next, and so on:

![smarky templated commands](https://user-images.githubusercontent.com/8827351/174421186-028d50ac-8df2-440a-8c4d-a6ccb8a1f4a9.gif)

You can even take this opportunity to invoke more well-behaved widgets.

### Index file (SQLite database)

When picking the database file to be used by the `sqlite3` command, smarky has
the following precedence:

1. The `SMARKY_INDEX` environment variable, if set.
2. The path `$XDG_DATA_DIR/smarky-index.db`, if `XDG_DATA_DIR` is set.
3. The path `$HOME/.local/share/smarky-index.db`.

For example, if you wish to use the file `/tmp/example.db` for the smarky
index, you can invoke smarky like this:

```sh
SMARKY_INDEX=/tmp/example.db smarky list
```

### Text editor (and the EDITOR variable)

When creating or updating bookmarks with smarky, smarky will invoke the text
editor `$EDITOR` for you to compose the command to store in its index. When
`EDITOR` is not set, smarky will attempt to use `nano`.
