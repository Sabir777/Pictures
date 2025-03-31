#!/bin/bash

#----------1.Перевод pdf в png (схемы; фон не меняется)----------#

# Сжатие PNG на выходе
# Конвертировать pdf в png: пакетная обработка (многостраничные pdf)
# Копирование директорий
# Вместо PDF-файла  будет создана папка с тем же именем в которой будут находиться PNG-страницы
# Результат в Output 


# Функция для преобразования PDF-страницы в PNG-картинку
# Дополнительно производится: Сжатие картинки
pdf_to_png() {
    input_pdf="$1"
    output_png="${input_pdf/%.pdf/.png}"

    # Получаю png из pdf
    convert -density 130 "$input_pdf" -quality 90 -background white -flatten "$output_png"

    # Сжатие png
    pngquant --quality=10-20 --speed 1 --ext .png --force "$output_png"

    # Сжатие через оптимизацию
    optipng -o7 -strip all -quiet "$output_png"

    # Финальное сжатие от Google (Zopfli)
    tmp_file="${output_png}.tmp"
    zopflipng --lossy_8bit --lossy_transparent "$output_png" "$tmp_file" && mv -f "$tmp_file" "$output_png"
}


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

