#!/bin/bash

#----------5.Конвертировать pdf в png (сохранение директорий)----------#

# Копирование директорий
# Конвертировать pdf в png: пакетная обработка
# Вместо PDF-файла  будет создана папка с тем же именем в которой будут находиться PNG-страницы
# Результат в папке Output


# Функция для преобразования PDF-страницы в PNG-картинку
# Дополнительно производится: 1) Осветление фона; 2) Сжатие картинки
pdf_to_png() {
    input_pdf="$1"
    output_png="${input_pdf/%.pdf/.png}"

    #---------------Первый проход---------------#
    # Преобразую PDF в PNG с высоким разрешением и осветляю фон
    convert -density 600 "$input_pdf" -alpha off -fuzz 20% -transparent "#e0e0e0" -level 10%,90% -contrast "$output_png"

    # Улучшаю контраст, делаю линии жирнее
    convert "$output_png" -blur 0x0.5 -sharpen 0x1 -level 80%,100% "$output_png"

    # Убираю прозрачность и добавляю белый фон
    convert "$output_png" -background white -alpha remove -alpha off "$output_png"

    # Сжимаю PNG
    pngquant --quality=10-20 "$output_png" --ext .png --force

    # Преобразую PNG обратно в PDF
    convert "$output_png" "$input_pdf"

    #---------------Второй проход---------------#
    # Преобразую в png со снижением разрешения
    convert -density 150 "$input_pdf" "$output_png"

    # Улучшаю контраст, делаю линии жирнее
    convert "$output_png" -blur 0x0.5 -sharpen 0x1 -level 80%,100% "$output_png"
    # Сжимаю PNG
    pngquant --quality=10-20 "$output_png" --ext .png --force

    # Преобразование PNG обратно в PDF
    convert "$output_png" "$input_pdf"

    #---------------Третий проход---------------#
    # Преобразование PDF в PNG с пониженным разрешением
    convert -density 130 "$input_pdf" -alpha off -fuzz 20% -transparent "#e0e0e0" -level 10%,90% -contrast "$output_png"

    # Добавление белого фона (чтобы фон был белым вместо прозрачного)
    convert "$output_png" -background white -alpha remove -alpha off "$output_png"

    # Сжимаем PNG с помощью pngquant (повышенная степень сжатия)
    pngquant --quality=10-20 "$output_png" --ext .png --force

}



# Копирую структуру папок из папки Input в Output
cd Input

# Запоминаю полное имя базовой директории
base_dir=$(pwd)

# Копирую только папки без файлов
find . -type d -exec mkdir -p ../Output/{} \;


# Нахожу все файлы в папке Input рекурсивно
# Если файл pdf - сжимаю его, если другого типа - копирую
find . -type f | while read file; do
  if [[ "$file" == *.pdf || "$file" == *.PDF ]]; then

    # Создаю директорию по имени файла
    dir_file="../Output/$file"
    mkdir -p "$dir_file"

    # определяю имя pdf-файла
    pdf_file=$(basename "$file")

    # копирую pdf-файл в папку с именем файла
    new_pdf="$dir_file/$pdf_file"
    cp "$file" "$new_pdf" 

    # Перехожу в папку с именем pdf-файла
    cd "$dir_file"

    # Разбираю PDF-файл на отдельные файлы (страницы документа)
    gs -dNOPAUSE -dBATCH -sDEVICE=pdfwrite -sOutputFile="${pdf_file%.*}_%04d.pdf" "$pdf_file"

    # Удаляю оригинальный PDF-файл
    rm "$pdf_file"

    # Конвертирую PDF-страницы в PNG-формат
    for page in *.pdf; do
        pdf_to_png "$page"
    done

    # Удаляю исходные PDF-страницы
    rm *.pdf

    # возвращаюсь в базовую директорию
    cd "$base_dir"

  else
    # если файл не pdf - копирую его
    cp "$file" "../Output/$file"
  fi
done

