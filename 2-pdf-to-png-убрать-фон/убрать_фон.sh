#!/bin/bash

#-------------Удаление фона---------------#

# Преобразовать pdf в папке Input в png с удалением фона
# Результат в папке Output

# Создаю папку "Output" если ее нет
mkdir -p Output

# Преобразую пдф в png с незначительным сжатием
# Удаляю фон
# Сохраняю файлы в парке Output
for file in Input/*.pdf; do
  filename=$(basename "$file")
  file_output="Output/${filename%.pdf}.png"
  convert -density 100 "$file" -alpha off -fuzz 10% -transparent white -quality 90 "$file_output"
done

# Перехожу в папку с созданными файлами и сжимаю их утилитой pngquant
cd Output
pngquant --quality=10-20 *.png --ext .png --force

