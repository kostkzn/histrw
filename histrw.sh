#!/bin/bash

SAVEFILE="/vagrant/kooky-file.txt"

# Check if there is input data via pipeline
if [ -t 0 ]; then
    echo "Error: No input data. Please use | to pass data to this script."
    exit 1
fi

process_info() {
    if [ -n "$1" ]; then  
        if ! [[ "$1" =~ ^[0-9]+$ ]]; then
            echo "Ошибка: Номер команды должен быть целым числом."
            exit 1
        fi
           
        while IFS= read -r line; do
            # Выполняйте здесь необходимую обработку для каждой строки (line)
            # Например, убираем начальные пробелы и записываем в файл output.txt
            ps_line=$(echo "$line" | awk -v num="$1" '$1 == num { $1 = ""; sub(/^[ \t]+/, ""); print }')
            if [ -n "$ps_line" ]; then
                break
            fi
        done

        if [ -z "$ps_line" ]; then
            echo "Ошибка: Команда с номером $1 не найдена в истории."
            exit 1 
        fi
    
        echo "$ps_line" >> ${SAVEFILE} && echo "Entered string: $ps_line" || { echo "FAIL!"; exit 1; }
    # exit 0    
    else
        prev_line=""
        while IFS= read -r line; do
            if [[ -n $line ]]; then
                prev_line="$last_line"
                last_line="$line"
            fi
        done
        ps_line=$(echo "$prev_line" | awk '{$1=""; sub(/^[ \t]+/, ""); print}') 
        echo "$ps_line" >> ${SAVEFILE} && echo "Entered string: $ps_line" || { echo "FAIL!"; exit 1; }
    fi
}


# main
if [ $# -eq 1 ]; then
    # Если передан номер команды как аргумент, извлекаем эту команду
    process_info $1
    exit 0 
elif [ $# -eq 0 ]; then
    # Если не передан номер команды, обрабатываем данные из входного потока
    process_info
    exit 0
else
    echo "Error: more than one argument"
    exit 1
fi




# process_info() {
#   while IFS= read -r line; do
#     # Выполняйте здесь необходимую обработку для каждой строки (line)
#     # Например, убираем начальные пробелы и записываем в файл output.txt
#     trimmed_line=$(echo "$line" | sed 's/^[[:space:]]*//')
#     echo "$trimmed_line" >> output.txt
#   done
# }

# Функция для обработки информации
# process_info() {
#     # Read input data via pipeline
#     while IFS= read -r line; do
#     # Output the input data
#     echo "Entered string: $line"
# done
# }
