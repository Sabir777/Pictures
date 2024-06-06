#!/bin/bash

#----------сжатие фото в папках----------#

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
  if [[ "$file" == *.jpg ]]; then
    magick "$file" -resize 25% -quality 20 "../Output/$file"
  else
    cp "$file" "../Output/$file"
  fi
done

