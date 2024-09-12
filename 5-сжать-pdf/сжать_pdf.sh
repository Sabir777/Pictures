#!/bin/bash

#----------Сжать pdf в папках----------#

# Копирование директорий
# Сжать pdf: пакетная обработка
# Результат в папке Output


# Создаю временную папку temp
mkdir -p temp

# Копирую структуру папок из папки Input в Output
cd Input
# Копирую только папки без файлов
find . -type d -exec mkdir -p ../Output/{} \;


# Нахожу все файлы в папке Input рекурсивно
# Если файл pdf - сжимаю его, если другого типа - копирую
find . -type f | while read file; do
  if [[ "$file" == *.pdf || "$file" == *.PDF ]]; then
    # magick "$file" -resize 25% -quality 20 "../Output/$file"
    # file_temp="../Output/${file%.pdf}.png"
    # копирую pdf-файл в папку temp
    cp "$file" ../temp/

    # перехожу в паку temp
    cd ../temp

    # определяю имя pdf-файла
    pdf_file=$(basename "$file")

    # получаю png-страницы из pdf (сжатие)
    gs -dSAFER -dBATCH -dNOPAUSE -sDEVICE=png16m -r100 -sOutputFile="page_%04d.png" "$pdf_file"

    # сжимаю png-страницы
    pngquant --quality=10-20 *.png --ext .png --force

    # создаю pdf из сжатых png-страниц
    magick *.png "../Output/$file" 

    # удаляю все файлы в папке temp
    rm -fr ./*
    cd ../Input

  else
    # если файл не pdf - копирую его
    cp "$file" "../Output/$file"
  fi
done

# удаляю временную папку
cd ..
rmdir temp
