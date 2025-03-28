#!/bin/bash

#--------8.Склеить pdf-страницы----------#

# Склеить pdf-документы
# Исходные pdf-файлы расположить в папке Input
# Новый документ будет находиться в папке Output

# Создаю папку "Output" если ее нет
mkdir -p Output

# Перехожу в папку Input
cd Input

# Создаю массив файлов files, отсортированный по числовому порядку 
mapfile -t files < <(ls *.pdf *.PDF 2>/dev/null | sort -V)

# Склеиваю pdf-фрагменты
gs -dBATCH -dNOPAUSE -q -sDEVICE=pdfwrite -sOutputFile=../Output/output.pdf "${files[@]}"

