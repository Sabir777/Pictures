#!/bin/bash

#--------------10.Сжатие png--------------#

# Сжать через преобразование: png-pdf-png
# Результат в папке Output (сжатые png-файлы)


# Функция для преобразования PDF-страницы в PNG-картинку
# Дополнительно производится: Сжатие картинки
pdf_to_png() {
    input_pdf="$1"
    output_png="${input_pdf/%.pdf/.png}"

    # Получаю png из pdf
    magick -density 20 "$input_pdf" -quality 90 -background white -flatten "$output_png"

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
# Если файл png - конвертирую его в pdf, если другого типа - копирую
find . -type f | while read file; do
    case "$file" in
        *.png|*.PNG)
          output_file="../Output/${file%.*}.pdf"
          name_file=${output_file##*/}
          # преобразую png в pdf
          magick "$file" "$output_file"
          # перехожу в директорию с pdf-файлом
          cd "${output_file%/*}"
          # преобразую pdf в png
          pdf_to_png "$name_file"
          rm "$name_file"
          cd "$base_dir"
          ;;
        *)
          cp "$file" "../Output/$file"
          ;;
    esac
done

