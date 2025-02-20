#!/bin/bash

#----------Конвертировать pdf в png (сохранение директорий)----------#

# Копирование директорий
# Конвертировать pdf в png: пакетная обработка
# Результат в папке Output


# Создаю временную папку temp
# mkdir -p temp

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

    # получаю png-страницы из pdf (poppler-utils) сжатие -r 90 (90DPI)
    pdftoppm -png -r 90 "$pdf_file" "${pdf_file%.*}"

    # сжимаю png-страницы
    pngquant --quality=10-20 *.png --ext .png --force

    # возвращаюсь в базовую директорию
    cd "$base_dir"

  else
    # если файл не pdf - копирую его
    cp "$file" "../Output/$file"
  fi
done

