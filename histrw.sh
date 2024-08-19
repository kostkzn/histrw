#!/bin/bash

# Usage:
#   `history | histrw.sh`
#   `history | histrw.sh 10`
#   `history | histrw.sh "# Comment"`

# Add aliases:
#   1. mkdir -v "$HOME/bin"
#   2. copy 
#   3. ln -s $HOME/bin/histrw.sh $HOME/bin/add
#   4. nano alias_add.bash
#   5. alias add="history | addd"
#   6. source alias_add.bash

SAVEFILE="$HOME/$(hostname)_histrw.txt"

### CUSTOM ERROR MESSAGES
ERROR_UNWRITABLE_SAVEFILE="Error: Cannot write to ${SAVEFILE}"
ERROR_UNABLE_CREATE="Error: Unable to create ${SAVEFILE}"
ERROR_NO_INPUT="Error: No input pipeline data. Please use | to pass data to this script."
ERROR_NOT_INTEGER="Error: Command number must be an integer OR be a '#comment_line' (in single quotes with starting hashtag)."
ERROR_COMMAND_NOT_FOUND="Error: Command with number %d not found in history.\n"
ERROR_TOO_MANY_ARGS="Error: Too many arguments."

process_pipe() {
    if [ -n "$1" ]; then
        if ! [[ "$1" =~ ^[0-9]+$ || "$1" =~ ^#.+$ ]]; then
            echo "${ERROR_NOT_INTEGER}"
            exit 1
        elif [[ "$1" =~ ^#.+$ ]]; then
            if printf "    %s\n" "$1" >>"${SAVEFILE}"; then
                echo "$SAVEFILE --> New comment: $1"
                exit 0
            else
                echo "${ERROR_UNWRITABLE_SAVEFILE}"
                exit 1
            fi
        fi

        while IFS= read -r line; do
            # Remove initial spaces
            ps_line=$(echo "$line" | awk -v num="$1" '$1 == num { $1 = ""; sub(/^[ \t]+/, ""); print }')
            if [ -n "$ps_line" ]; then
                break
            fi
        done

        if [ -z "$ps_line" ]; then
            # shellcheck disable=SC2059
            printf "${ERROR_COMMAND_NOT_FOUND}" "$1"
            exit 1
        fi

        if echo "$ps_line" >>"${SAVEFILE}"; then
            echo "$SAVEFILE --> New record: $ps_line"
        else
            echo "${ERROR_UNWRITABLE_SAVEFILE}"
            exit 1
        fi
    else
        prev_line=""
        while IFS= read -r line; do
            if [[ -n $line ]]; then
                prev_line="$last_line"
                last_line="$line"
            fi
        done
        ps_line=$(echo "$prev_line" | awk '{$1=""; sub(/^[ \t]+/, ""); print}')

        if echo "$ps_line" >>"${SAVEFILE}"; then
            echo "New record: $ps_line"
        else
            echo "${ERROR_UNWRITABLE_SAVEFILE}"
            exit 1
        fi
    fi
}

# main
if [ ! -f "${SAVEFILE}" ]; then
    touch "${SAVEFILE}" || {
        echo "${ERROR_UNABLE_CREATE}"
        exit 1
    }
    echo "File ${SAVEFILE} has been created."
fi

if [ ! -w "${SAVEFILE}" ]; then
    echo "${ERROR_UNWRITABLE_SAVEFILE}"
    exit 1
fi

# Check if there is input data via pipeline
if [ -t 0 ]; then
    echo "${ERROR_NO_INPUT}"
    exit 1
fi

if [ $# -eq 1 ]; then
    # Если передан номер команды как аргумент, извлекаем эту команду
    process_pipe "$*"
    exit 0
elif [ $# -eq 0 ]; then
    # Если не передан номер команды, обрабатываем данные из входного потока
    process_pipe
    exit 0
else
    echo "${ERROR_TOO_MANY_ARGS}"
    exit 1
fi
