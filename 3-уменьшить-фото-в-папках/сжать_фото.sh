#!/bin/bash

# Создаю папку Output - если она не существует
mkdir -p Output

# Копируем структуру папок из Input в Output
cp -r Input/* Output/

# Находим все файлы jpg в папке Output и её подпапках
find Output -type f -name "*.jpg" | while read jpg_file; do
    # Получаем имя папки, в которой находится файл
    output_dir=$(dirname "$jpg_file")
    # Сжимаем jpg файл программой ImageMagick
    magick convert "$jpg_file" -resize 50% "$jpg_file"
done

# Копируем все файлы, не являющиеся jpg, из Input в Output
find Output -type f ! -name "*.jpg" -exec cp --parents {} Output/ \;
