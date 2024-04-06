#!/bin/bash

# Проверяем, существует ли каталог "Output"
if [ ! -d "Output" ]; then
  mkdir "Output"  # Создаем каталог, если его нет
fi

# Преобразую пдф в png с незначительным сжатием
# Сохраняю файлы в парке Output
for file in $(ls *.pdf); do
  file_output="${file%.pdf}.png"
  convert -density 100 "$file" -quality 90 -background white -flatten "Output/$file_output"
done

# Перехожу в папку с созданными файлами и сжимаю их утилитой pngquant
cd Output
pngquant --quality=10-20 *.png --ext .png --force

