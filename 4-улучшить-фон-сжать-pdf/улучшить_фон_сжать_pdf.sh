#!/bin/bash

#----------4.Улучшить фон, сжать pdf в папках----------#

# Копирование директорий
# Сжать pdf: пакетная обработка
# Скрипт делает фон светлым, сжимает pdf
# Результат в папке Output

# Копирую структуру папок из папки Input в Output
cd Input
# Копирую только папки без файлов
find . -type d -exec mkdir -p ../Output/{} \;

# Нахожу все файлы в папке Input рекурсивно
# Если файл pdf - сжимаю его, если другого типа - копирую
find . -type f | while read file; do
  if [[ "$file" == *.pdf || "$file" == *.PDF ]]; then
    # сжимаю pdf-файл
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
     "$file"
  else
    # если файл не pdf - копирую его
    cp "$file" "../Output/$file"
  fi
done

