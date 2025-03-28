#!/bin/bash

#----------9.сжатие фото в папках----------#

# Копирование директорий
# Сжатие jpg
# Результат в папке Output

# Копирую структуру папок из папки Input в Output
cd Input
# Копирую только папки без файлов
find . -type d -exec mkdir -p ../Output/{} \;


# Нахожу все файлы в папке Input рекурсивно
# Если файл jpg - конвертирую его, если другого типа - копирую
find . -type f | while read file; do
    if [[ "$file" == *.jpg || "$file" == *.JPG ]]; then
        output_file="../Output/${file/%.JPG/.jpg}"
        magick "$file" -resize 50% -quality 80 "$output_file"
        jpegoptim --max=40 "$output_file"
    else
        cp "$file" "../Output/$file"
    fi
done

