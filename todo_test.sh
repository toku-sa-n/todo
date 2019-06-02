#!/bin/zsh

TODO_FILE=~/.todo
TODO_BACKUP=~/.todo_bk

cp $TODO_FILE $TODO_BACKUP

# when no argumentsa are given, show help.
[[ $(./todo.sh) = $(./todo.sh help) ]] && echo OK

mv $TODO_BACKUP $TODO_FILE
