#!/bin/bash

#-------9.Сборка PDF из PNG-страниц------#

# Преобразовать png в папке Input в pdf
# Результат в папке Output
# Если папка в которой находятся png-страницы называется *.pdf (*.PDF) то удаляю png-страницы и если папка пуста, удаляю саму папку; Готовый pdf-файл перемещаю на уровень выше (..)



# Копирую структуру папок из папки Input в Output
cd Input

# Запоминаю полное имя базовой директории
base_dir=$(pwd)

# Копирую только папки без файлов
find . -type d -exec mkdir -p ../Output/{} \;


# Нахожу все файлы в папке Input рекурсивно
# Если файл pdf - сжимаю его, если другого типа - копирую
find . -type f | while read file; do
  if [[ "$file" == *.pdf || "$file" == *.PDF ]]; then

    # Создаю директорию по имени файла
    dir_file="../Output/$file"
    mkdir -p "$dir_file"

    # определяю имя pdf-файла
    pdf_file=$(basename "$file")

    # копирую pdf-файл в папку с именем файла
    new_pdf="$dir_file/$pdf_file"
    cp "$file" "$new_pdf" 

    # Перехожу в папку с именем pdf-файла
    cd "$dir_file"

    # Разбираю PDF-файл на отдельные файлы (страницы документа)
    gs -dNOPAUSE -dBATCH -sDEVICE=pdfwrite -sOutputFile="${pdf_file%.*}_%04d.pdf" "$pdf_file"

    # Удаляю оригинальный PDF-файл
    rm "$pdf_file"

    # Конвертирую PDF-страницы в PNG-формат
    for page in *.pdf; do
        pdf_to_png "$page"
    done

    # Удаляю исходные PDF-страницы
    rm *.pdf

    # возвращаюсь в базовую директорию
    cd "$base_dir"

  else
    # если файл не pdf - копирую его
    cp "$file" "../Output/$file"
  fi
done

