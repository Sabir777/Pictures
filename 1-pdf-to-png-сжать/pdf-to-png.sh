#!/bin/bash

# Копирую структуру папок из папки Input в Output
cd Input
# Копирую только папки без файлов
find . -type d -exec mkdir -p ../Output/{} \;


# Нахожу все файлы в папке Input рекурсивно
# Если файл pdf - конвертирую и уменьшаю его, если другого типа - копирую
find . -type f | while read file; do
  if [[ "$file" == *.pdf ]]; then
    file_output="../Output/${file%.pdf}.png"
    convert -density 100 "$file" -quality 90 -background white -flatten "$file_output"
    pngquant --quality=10-20 "$file_output" --ext .png --force
  else
    cp "$file" "../Output/$file"
  fi
done


