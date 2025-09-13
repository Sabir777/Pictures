#!/bin/bash

#----------13.Добавить пустое пространство----------#

# Копирование директорий
# Добавление полей в картинках: пакетная обработка
# Результат в папке Output

# Задаю размеры полей: сверху, снизу, слева и справа
# Толщина полоски в пикселях
# синтаксис 'ширинаxвысота' - 150 пикселей

# Добавить полоску сверху: "0x100"
up="0x0"

# Добавить полоску снизу: "0x100"
down="0x0"

# Добавить полоску слева: "100x0"
left="0x0"

# Добавить полоску справа: "100x0"
right="0x0"


# Копирую структуру папок из папки Input в Output
cd Input
# Копирую только папки без файлов
find . -type d -exec mkdir -p ../Output/{} \;


# Нахожу все файлы в папке Input рекурсивно
# Если файл jpg или png - конвертирую его, если другого типа - копирую
find . -type f | while read file; do
  if [[ "$file" == *.jpg || "$file" == *.png || "$file" == *.JPG || "$file" == *.PNG ]]; then
    convert "$file" -gravity north -background white -splice "$up" -gravity south -background white -splice "$down" -gravity west -background white -splice "$left" -gravity east -background white -splice "$right" "../Output/$file"
  else
    cp "$file" "../Output/$file"
  fi
done

