#!/bin/bash

#----------11.Перевод pdf в jpg----------#

# Конвертировать pdf в jpg: пакетная обработка (многостраничные pdf)
# Копирование директорий
# Вместо PDF-файла  будет создана папка с тем же именем в которой будут находиться jpg-страницы
# Результат в Output 


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
    # определяю базовое имя jpg-коллекции (pdf to jpg)
    jpg_name="${pdf_file%.*}"

    # копирую pdf-файл в папку с именем файла
    new_pdf="$dir_file/$pdf_file"
    cp "$file" "$new_pdf" 

    # Перехожу в папку с именем pdf-файла
    cd "$dir_file"

    # Преобразую pdf в jpg
    # Разбираю PDF-файл на отдельные jpg-файлы (страницы документа)
    pdftoppm -jpeg -r 300 "$pdf_file" "$jpg_name"

    # Удаляю оригинальный PDF-файл
    rm "$pdf_file"

    # возвращаюсь в базовую директорию
    cd "$base_dir"

  else
    # если файл не pdf - копирую его
    cp "$file" "../Output/$file"
  fi
done

