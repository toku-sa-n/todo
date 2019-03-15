#!/bin/zsh

COMMAND=$1
TODO_FILE=~/.todo

RED='\\e[31m'
GREEN='\\e[32m'
RESET_COLOR='\\e[m'

touch $TODO_FILE
case $COMMAND in
    "add" )
        echo "$2,0" >> $TODO_FILE ;;
    "check" )
        sed "$2"'s/\(\w\+\),0/\1,1/' -i $TODO_FILE ;;
    "uncheck" )
        sed "$2"'s/\(\w\+\),1/\1,0/' -i $TODO_FILE ;;
    "delete" )
        sed "$2"'d' -i $TODO_FILE ;;
    "show" )
        echo -e "$(cat $TODO_FILE|sed "s/\(.\+\),0/$RED□ \1$RESET_COLOR/"|sed "s/\(.\+\),1/$GREEN✓ \1$RESET_COLOR/")"   ;;
    * ) cat<<EOF
    Usage: todo COMMAND
        add     TODO:   Add a todo.
        check   NUMBER: Mark a todo as done.
        uncheck NUMBER: Mark a todo as undone.
        delete  NUMBER: Delete a todo.
        show:           Show todos.
EOF
        exit 1 ;;
esac
