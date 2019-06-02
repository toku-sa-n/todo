#!/bin/bash

# The format of TODO_FILE
# {content of todo},{done(1) or undone(0)},{level}
# level: 0 is root. level of subtodos starts from 1.

TODO_FILE=~/.todo

RED='\\e[31m'
GREEN='\\e[32m'
RESET_COLOR='\\e[m'

# Because from inside a function, we can't refer to command line arguments,
# introduce ARGV array so that refer to command line arguments.
ARGV=("$@")

touch $TODO_FILE
show_help () {
cat<<EOF
Usage: todo COMMAND ARGUMENTS
    add     TODO:        Add a todo.
    check   NUMBER:      Mark a todo as done.
    uncheck NUMBER:      Mark a todo as undone.
    change  NUMBER TODO: Change a todo.
    delete  NUMBER:      Delete a todo.
    subtodo NUMBER TODO: Add a subtodo.
    show:                Show todos.
    help:                Show this message.
EOF
}

show_help_if_argument_is_null () {
    # $1 is the number of needed arguments.
    for argument_index in `seq $1`
    do
        if [ "${ARGV[$argument_index]}" = "" ]; then
            show_help
            exit 1
        fi
    done
}

is_number () {
    if [[ ! $1 =~ ^[0-9]+$ ]]; then
        echo "Invalid number: $1"
        exit 1
    fi
}

decrease_todo_levels () {
    # decrease the level of each todo from ln ${ARGV[1]}. if the todo of level 0(root) appear, finish the process.
    line=${ARGV[1]}
    while true
    do
        if [ $line -gt `wc -l $TODO_FILE|awk '{print $1}'` ]; then
            exit
        fi

        level=`cat $TODO_FILE|awk -F "," '{print $3}'|sed -n "$line p"`
        if [ $level -eq 0 ]; then
            exit
        fi

        ((level--))
        sed "$line"'s/[0-9]\+$/'"$level/" -i $TODO_FILE
        ((line++))
    done
}

# TODO: Use awk instead of sed ASAP.
# TODO: Separate into functions.

case "${ARGV[0]}" in
    "add" )
        show_help_if_argument_is_null 1
        echo "${ARGV[1]},0,0" >> $TODO_FILE ;;

    "check" )
        show_help_if_argument_is_null 1
        is_number ${ARGV[1]}
        sed "${ARGV[1]}"'s/\(\w\+\),0,\([0-9]\+\)/\1,1,\2/' -i $TODO_FILE ;;

    "uncheck" )
        show_help_if_argument_is_null 1
        is_number ${ARGV[1]}
        sed "${ARGV[1]}"'s/\(\w\+\),1,\([0-9]\+\)/\1,0,\2/' -i $TODO_FILE ;;

    "change" )
        show_help_if_argument_is_null 2
        is_number ${ARGV[1]}
        sed "${ARGV[1]}"'s/.\+,\([01]\)/'"${ARGV[2]}"',\1/' -i $TODO_FILE ;;

    "delete" )
        show_help_if_argument_is_null 1
        is_number ${ARGV[1]}

        # Delete the specified todo.
        sed "${ARGV[1]}"'d' -i $TODO_FILE

        # Decrease the level of subtodos which followed the deleted todo.
        decrease_todo_levels ${ARGV[1]}
        ;;
    "subtodo" )
        show_help_if_argument_is_null 2
        is_number ${ARGV[1]}

        # Get the level of parent todo.
        parent_level=`cat $TODO_FILE|sed -n "${ARGV[1]} p "|sed 's/.\+,\([0-9]\+\)/\1/'`
        ((parent_level+=1))
        sed "${ARGV[1]}"' a '"${ARGV[2]},0,${parent_level}" -i $TODO_FILE ;;

    "show" )
        # To arrange the vertical line of the indexes, calculate the digits.
        digit_number=$(echo $(wc -l $TODO_FILE|awk '{print $1}')/10+1|bc)
        line_index=1

        while IFS=: read -r line
        do
            printf "%${digit_number}d " $line_index

            # Check whether todo is a subgoal or not.
            todo_level=$(echo $line|sed "s/.\+,\([0-9]\+\)/\1/")
            indent_arrow=""
            if [ ${todo_level} -ne 0 ]; then
                for i in `seq $todo_level`
                do
                    indent_arrow+="-"
                done
                echo -n "$indent_arrow> "
            fi

            echo -e "$(echo $line|sed "s/\(.\+\),[0-9]\+/\1/"|sed "s/\(.\+\),0/$RED□ \1$RESET_COLOR/"|sed "s/\(.\+\),1/$GREEN✓ \1$RESET_COLOR/")"
            ((line_index++))
        done <"$TODO_FILE" ;;

    "help" )
        show_help ;;

    * )
        show_help
        exit 1 ;;
esac
