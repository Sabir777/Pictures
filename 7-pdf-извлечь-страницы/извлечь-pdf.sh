#!/bin/bash

#--------7.Извлечь pdf-страницы----------#

# Извлечь pdf-страницы из pdf-документа
# Исходный pdf-файл расположить в папке Input
# Результат будет находиться в папке Output

# Задаю диапазоны извлекаемых страниц
# Пример: pages="1-1 4-9 31-32"
# На выходе получаю: страницу-1, страницы:4-9, страницы 31-32

pages="138-138"

# Создаю папку "Output" если ее нет
mkdir -p Output

# Перехожу в папку Input
cd Input

# Считываю первый pdf-файл в текущей директории
files=(*.pdf *.PDF)
file="${files[0]}"

# Перебираю диапазоны
for range in $pages; do
    # Извлекаю страницы из документа
    qpdf "$file" --pages . "$range" -- "../Output/${file%.*}_${range}.pdf"
done

