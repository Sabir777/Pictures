#!/bin/bash

#-5.Конвертировать pdf в png (осветление фона и увеличение толщины линий)-#

# Сжатие PNG на выходе
# Копирование директорий
# Конвертировать pdf в png: пакетная обработка (многостраничные pdf)
# Вместо PDF-файла  будет создана папка с тем же именем в которой будут находиться PNG-страницы
# Результат в папке Output


# Функция для преобразования PDF-страницы в PNG-картинку
# Дополнительно производится: 1) Осветление фона; 2) Сжатие картинки
pdf_to_png() {
    input_pdf="$1"
    output_png="${input_pdf/%.pdf/.png}"

    gs -dNOPAUSE -dBATCH -q \
       -sDEVICE=png16m \
       -r130 \
       -sOutputFile="$output_png" \
       "$input_pdf"

    # Осветление фона и увеличение толщины линий
    convert "$output_png" -alpha off -fuzz 20% -transparent "#e0e0e0" -level 10%,90% -contrast-stretch 5x95% -blur 0x0.3 -sharpen 0x3 -level 40%,100% -morphology Close Diamond -background white -alpha remove -alpha off "$output_png"

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

