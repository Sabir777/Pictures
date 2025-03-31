#!/bin/bash

# Если сессия существует - подключаюсь к ней, если нет то создаю сессию
tmux has-session -t Pictures
if [ $? == 0 ];then
  tmux attach -t Pictures
  exit
fi

# Задаю текущую директорию tmux
cd ~/my_WSL2/Pictures/


# Запускаю 1-е окно: 1-pdf-to-png-сжать
# создаю сессию "Pictures" и окно "pic-1"
tmux new-session -s Pictures -n pic-1 -d

# Открываю в vim "pdf-to-png.sh"
tmux send-keys -t Pictures 'cd 1-pdf-to-png-сжать ; vim pdf-to-png.sh' C-m


# Запускаю 2-е окно: 2-pdf-to-png-белый-фон
# создаю окно "pic-2" в сессии Pictures
tmux new-window -n pic-2 -t Pictures

# Открываю в vim "pdf-to-png-белый-фон.sh"
tmux send-keys -t Pictures:2.1 'cd 2-pdf-to-png-белый-фон ; vim pdf-to-png-белый-фон.sh' C-m


# Запускаю 3-е окно: 3-pdf-to-png-убрать-фон
# создаю окно "pic-3" в сессии Pictures
tmux new-window -n pic-3 -t Pictures

# Открываю в vim "pdf-to-png-убрать-фон.sh"
tmux send-keys -t Pictures:3.1 'cd 3-pdf-to-png-убрать-фон ; vim pdf-to-png-убрать-фон.sh' C-m


# Запускаю 4-е окно: 4-pdf-to-pdf-сжать
# создаю окно "pic-4" в сессии Pictures
tmux new-window -n pic-4 -t Pictures

# Открываю в vim "сжать_pdf.sh"
tmux send-keys -t Pictures:4.1 'cd 4-pdf-to-pdf-сжать ; vim сжать_pdf.sh' C-m


# Запускаю 5-е окно: 5-pdf-png-pdf-сжатие
# создаю окно "pic-5" в сессии Pictures
tmux new-window -n pic-5 -t Pictures

# Открываю в vim "агрессивное_сжатие_pdf.sh"
tmux send-keys -t Pictures:5.1 'cd 5-pdf-png-pdf-сжатие ; vim агрессивное_сжатие_pdf.sh' C-m


# Запускаю 6-е окно: 6-pdf-to-pdf-белый-фон
# создаю окно "pic-6" в сессии Pictures
tmux new-window -n pic-6 -t Pictures

# Открываю в vim "улучшить_фон_сжать_pdf.sh"
tmux send-keys -t Pictures:6.1 'cd 6-pdf-to-pdf-белый-фон ; vim улучшить_фон_сжать_pdf.sh' C-m


# Запускаю 7-е окно: 7-pdf-извлечь-страницы
# создаю окно "pic-7" в сессии Pictures
tmux new-window -n pic-7 -t Pictures

# Открываю в vim "добавить-пустое-место-картинки.sh"
tmux send-keys -t Pictures:7.1 'cd 7-pdf-извлечь-страницы ; vim извлечь-pdf.sh' C-m


# Запускаю 8-е окно: 8-pdf-склеить-документы
# создаю окно "pic-8" в сессии Pictures
tmux new-window -n pic-8 -t Pictures

# Открываю в vim "склеить-pdf.sh"
tmux send-keys -t Pictures:8.1 'cd 8-pdf-склеить-документы ; vim склеить-pdf.sh' C-m


# Запускаю 9-е окно: 9-png-to-pdf-сборка
# создаю окно "pic-9" в сессии Pictures
tmux new-window -n pic-9 -t Pictures

# Открываю в vim "png-to-pdf-сборка.sh"
tmux send-keys -t Pictures:9.1 'cd 9-png-to-pdf-сборка ; vim png-to-pdf-сборка.sh' C-m


# Запускаю 10-е окно: 10-jpg-сжать-фото
# создаю окно "pic-10" в сессии Pictures
tmux new-window -n pic-10 -t Pictures

# Открываю в vim "сжать_фото.sh"
tmux send-keys -t Pictures:10.1 'cd 10-jpg-сжать-фото ; vim сжать_фото.sh' C-m


# Запускаю 11-е окно: 11-jpg-добавить-поля
# создаю окно "pic-11" в сессии Pictures
tmux new-window -n pic-11 -t Pictures

# Открываю в vim "добавить-пустое-место-картинки.sh"
tmux send-keys -t Pictures:11.1 'cd 11-jpg-добавить-поля ; vim добавить-пустое-место-картинки.sh' C-m

# Подключаюсь к сессии "Pictures"      
tmux attach -t Pictures

