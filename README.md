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

```
Usage information:
  smarky create [description] [command] ----- add a mark to the index
  smarky update id [description] [command] -- edit a mark in the index
  smarky remove id -------------------------- remove command by id
  smarky select id -------------------------- get command by id
  smarky list ------------------------------- list all added commands
  smarky [help|usage|etc.] ------------------ display usage information
```

While smarky can be used by directly invoking the command, it's made to be
simple enough it becomes a little useless when you want to retrieve commands to
use in real time. To get more use out of it, you'll need to use ZSH and the
accompanying ZLE widget present in this repository.

The default binding to retrieve commands from smarky using a widget is
`Ctrl-J`. You can get the binding and the widget in your shell configuration by
adding the following to your `.zshrc`:

```sh
source path/to/the/smarky/repo/zsh/widgets.zsh
```

Once that is done, add bookmarks to smarky and press Ctrl-J to see the fzf
widget that'll help you select your bookmark and put it on the command line:

```sh
$ smarky create "extract a gzipped tarball (.tar.gz)" "tar xvzf "
$ # press Ctrl + J here
```
