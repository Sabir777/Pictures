#!/bin/bash

#----------4.Улучшить фон, сжать pdf в папках----------#

# Копирование директорий
# Сжать pdf: пакетная обработка
# Скрипт делает фон светлым, сжимает pdf
# Результат в папке Output


# Функция для сжатия PDF с осветлением фона
compress_pdf() {

    # Имя страницы
    output_pdf="$1"
    output_png="output.png"

    #---------------Первый проход---------------#
    # Преобразование PDF в PNG с пониженным разрешением
    convert -density 200 "$output_pdf" -alpha off -fuzz 20% -transparent "#e0e0e0" -level 10%,90% -contrast "$output_png"

    # Применяем фильтр для выделения контуров, чтобы линии стали более жирными
    convert "$output_png" -blur 0x1 -sharpen 0x1 -level 30%,100% "$output_png"

    # Добавление белого фона (чтобы фон был белым вместо прозрачного)
    convert "$output_png" -background white -alpha remove -alpha off "$output_png"

    # Сжимаем PNG с помощью pngquant (повышенная степень сжатия)
    pngquant --quality=5-15 "$output_png" --ext .png --force

    # Преобразование PNG обратно в PDF
    convert "$output_png" "$output_pdf"


    #---------------Второй проход---------------#
    # Преобразую в png со снижением разрешения
    convert -density 150 "$output_pdf" "$output_png"

    # Применяем фильтр для выделения контуров, чтобы линии стали более жирными
    convert "$output_png" -blur 0x1 -sharpen 0x1 -level 30%,100% "$output_png"

    # Сжимаем PNG с помощью pngquant (повышенная степень сжатия)
    pngquant --quality=5-15 "$output_png" --ext .png --force

    # Преобразование PNG обратно в PDF
    convert "$output_png" "$output_pdf"


    #---------------Третий проход---------------#
    # Преобразование PDF в PNG с пониженным разрешением
    convert -density 130 "$output_pdf" -alpha off -fuzz 20% -transparent "#e0e0e0" -level 10%,90% -contrast "$output_png"

    # Добавление белого фона (чтобы фон был белым вместо прозрачного)
    convert "$output_png" -background white -alpha remove -alpha off "$output_png"

    # Сжимаем PNG с помощью pngquant (повышенная степень сжатия)
    pngquant --quality=5-15 "$output_png" --ext .png --force

    # Преобразование PNG обратно в PDF
    convert "$output_png" "$output_pdf"
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
         -dColorImageResolution=144 \
         -dGrayImageDownsampleType=/Bicubic \
         -dGrayImageResolution=144 \
         -dMonoImageDownsampleType=/Subsample \
         -dMonoImageResolution=144 \
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


