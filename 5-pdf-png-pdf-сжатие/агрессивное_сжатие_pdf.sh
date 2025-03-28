#!/bin/bash

#----------5.Агрессивное сжатие PDF----------#

# Данный способ может быть неэффективным. Вначале лучше использовать 4-pdf-to-pdf-сжать - если способ не помог, можно попробывать ЭТОТ способ

# Копирование директорий
# Сжать pdf: пакетная обработка
# Результат в папке Output


# Функция для сжатия PDF
compress_pdf() {
    local input_pdf="$1"
    local output_png="output.png"

    # Получаю png из pdf
    magick -density 130 "$input_pdf" -quality 90 -background white -flatten "$output_png"


    # Сжатие png
    pngquant --quality=10-20 --speed 1 --ext .png --force "$output_png"

    # Сжатие через оптимизацию
    optipng -o7 -strip all -quiet "$output_png"

    # Финальное сжатие от Google (Zopfli)
    tmp_file="${output_png}.tmp"
    zopflipng --lossy_8bit --lossy_transparent "$output_png" "$tmp_file" && mv -f "$tmp_file" "$output_png"


    # Преобразую PNG в PDF
    magick "$output_png" "$input_pdf"

    # Удаляю временный PNG
    rm "$output_png"
}



# Копирую структуру папок из папки Input в Output
# Перехожу в базовую директорию
cd Input

# Запоминаю базовую директорию
base_dir=$(pwd)

# Создаю временную папку
mkdir -p ../temp

# Копирую только папки без файлов
find . -type d -exec mkdir -p ../Output/{} \;

# Нахожу все файлы в папке Input рекурсивно
# Если файл pdf - сжимаю его, если другого типа - копирую
find . -type f | while read file; do
    if [[ "$file" == *.pdf || "$file" == *.PDF ]]; then

        # определяю имя pdf-файла
        pdf_file=$(basename "$file")

        # Копирую файл во временную папку
        cp "$file" ../temp

        # Перехожу во временную папку
        cd ../temp

        # Разбираю PDF-файл на отдельные файлы (страницы документа)
        gs -dNOPAUSE -dBATCH -sDEVICE=pdfwrite -sOutputFile=page_%04d.pdf "$pdf_file"

        # Удаляю оригинальный PDF-файл из папки temp
        rm "$pdf_file"

        # Обрабатываю страницы документа
        for page in *.pdf; do
            compress_pdf "$page"
        done

        # Собираю PDF-документ из обработанных PDF-страниц
        gs -dNOPAUSE -dBATCH -sDEVICE=pdfwrite -sOutputFile="$pdf_file" page_*.pdf

        # Дополнительно сжимаю pdf-файл и сохраняю его в целевой директории
        gs -q -dNOPAUSE -dBATCH -dSAFER \
         -sDEVICE=pdfwrite \
         -dCompatibilityLevel=1.4 \
         -dPDFSETTINGS=/screen \
         -dEmbedAllFonts=true -dSubsetFonts=true \
         -dColorImageDownsampleType=/Bicubic \
         -dColorImageResolution=130 \
         -dGrayImageDownsampleType=/Bicubic \
         -dGrayImageResolution=130 \
         -dMonoImageDownsampleType=/Subsample \
         -dMonoImageResolution=130 \
         -sOutputFile="../Output/$file" \
         "$pdf_file"

        # Удаляю pdf-файлы в папке temp
        rm "$base_dir"/../temp/*.pdf

        # Возвращаюсь в базовую директорию
        cd "$base_dir"
  else
    # если файл не pdf - копирую его
    cp "$file" "../Output/$file"
  fi
done

# Удаляю папку temp
rm -fr ../temp/


