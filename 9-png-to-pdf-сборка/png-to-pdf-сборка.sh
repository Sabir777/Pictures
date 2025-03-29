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

# Перебираю рекурсивно все папки: в каждой директории проверяю наличие png-файлов и собираю pdf-файл
find . -type d | while read folder; do

    # Перехожу в каждую из папок
    cd "$folder"

    # Получаю имя папки
    name_dir=$(basename "$folder")

    # Создаю массив из имен png-файлов
    png_arr=($(ls *.png *.PNG | sort -V))

    # Если в папке нет png-файлов: прокрутка цикла
    if [[ ${#png_arr[@]} -eq 0 ]]; then
        cd "$base_dir"
        continue
    fi

    # Имя выходного файла
    output_file="output.pdf"

    # Проверяю соответствие текущей папки шаблону
    if [[ "$name_dir" == *.pdf || "$name_dir" == *.PDF ]]; then
        output_file="$name_dir"

        # Собираю pdf-файл
        magick "${png_arr[@]}" "$output_file"
        # Перемещаю pdf-файл на уровень вверх
        mv "$output_file" "../$output_file"
    else
        # Собираю pdf-файл
        magick "${png_arr[@]}" "$output_file"
    fi

    # Удаляю png-файлы
    rm *.png *.PNG

    # возвращаюсь в базовую директорию
    cd "$base_dir"

    # Если папка пуста удаляю данную папку
    rmdir "$folder" 2>/dev/null
done

