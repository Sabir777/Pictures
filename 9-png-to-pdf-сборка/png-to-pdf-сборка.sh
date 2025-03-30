#!/bin/bash

#-------9.Сборка PDF из PNG-страниц------#

# Преобразовать png в папке Input в pdf
# Результат в папке Output
# Если папка в которой находятся png-страницы называется *.pdf (*.PDF) то удаляю png-страницы и если папка пуста, удаляю саму папку; Готовый pdf-файл перемещаю на уровень выше (..)



# Копирую структуру папок из папки Input в Output
cd Input

# Копирую только папки без файлов
find . -type d -exec mkdir -p ../Output/{} \;

# Копирую файлы в подобную директорию
find . -type f | while read file; do
    cp "$file" "../Output/$file"
done


# Базовая директория: папка Output
cd ../Output

# Запоминаю полное имя базовой директории
base_dir=$(pwd)

# Создаю словарь для удаления папок и переименования временных файлов
declare -A lst_del

# Перебираю рекурсивно все папки: в каждой директории проверяю наличие png-файлов и собираю pdf-файл
mapfile -t folders < <(find . -type d)
for folder in "${folders[@]}"; do

    # Перехожу в каждую из папок
    cd "$folder"

    # Получаю имя папки
    name_dir=$(basename "$folder")

    # Создаю массив из имен png-файлов
    mapfile -t png_arr < <(find . -maxdepth 1 -type f \( -name "*.png" -o -name "*.PNG" \) | sort -V)


    # Если в папке нет png-файлов: прокрутка цикла
    if [[ ${#png_arr[@]} -eq 0 ]]; then
        cd "$base_dir"
        continue
    fi

    # Имя для выходного pdf-файла
    output_file="output.pdf"


    # Проверяю соответствие текущей папки шаблону
    if [[ "$name_dir" == *.pdf || "$name_dir" == *.PDF ]]; then

        # Имя для выходного pdf-файла
        output_file="$name_dir"

        # Собираю pdf-файл
        magick "${png_arr[@]}" "${output_file/%PDF/pdf}"

        # Перемещаю pdf-файл на уровень вверх
        temp_pdf="$(cd ..;pwd)/${output_file}.temp"
        mv "$output_file" "$temp_pdf"

        # Добавляю файл в список на переименование
        lst_del["$(pwd)"]="$temp_pdf"

    else
        # Собираю pdf-файл
        magick "${png_arr[@]}" "$output_file"
    fi


    # Удаляю массив
    unset png_arr

    # Удаляю png-файлы
    find . -maxdepth 1 -type f \( -name "*.png" -o -name "*.PNG" \) -exec rm {} +

    # возвращаюсь в базовую директорию
    cd "$base_dir"

done


# Удаляю пустые папки и переименовываю временные файлы
for folder in "${!lst_del[@]}"; do
    temp_pdf="${lst_del[$folder]}"

    # Если папка пуста удаляю данную папку
    if [ -z "$(find "$folder" -maxdepth 1 -mindepth 1 -print -quit)" ]; then
        rmdir "$folder"

        # Возвращаю имя pdf-файлу
        mv "$temp_pdf" "${temp_pdf%.temp}"
    fi
done
