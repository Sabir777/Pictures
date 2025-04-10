#!/bin/bash

#-------------3.Удаление фона и масштабирование PNG---------------#

# Преобразовать pdf в папке Input в png с удалением фона
# и масштабированием по ширине с сохранением пропорций
# Результат в папке Output

# Создаю папку "Output" если ее нет
mkdir -p Output

# Ширина изображения (в пикселях) - для большей четкости лучше 1024, с последующим уменьшением до 150
WIDTH=150

# Ширина изображения (в пикселях) - параметр задается так: -resize x${HEIGHT} \
# HEIGHT=768

# Преобразую pdf в png, удаляю фон, масштабирую по ширине
for file in Input/*.pdf; do
  filename=$(basename "$file")
  file_output="Output/${filename%.pdf}.png"
  magick -density 100 "$file" \
    -alpha off \
    -fuzz 10% -transparent white \
    -resize ${WIDTH}x \
    -quality 90 "$file_output"
done

# Перехожу в Output и сжимаю PNG
cd Output
pngquant --quality=10-20 *.png --ext .png --force
